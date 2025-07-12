import React, { useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/supabase';
import { Bell, AlertTriangle, CheckCircle, Clock, Calendar } from 'lucide-react';
import { format, isAfter, subDays, endOfMonth, subMonths } from 'date-fns';

type Patient = Database['public']['Tables']['patients']['Row'];
type Notification = Database['public']['Tables']['notifications']['Row'];
type NotificationInsert = Database['public']['Tables']['notifications']['Insert'];
type NotificationUpdate = Database['public']['Tables']['notifications']['Update'];

const NotificationCenter: React.FC = () => {
  const [patients, setPatients] = React.useState<Patient[]>([]);
  const [notifications, setNotifications] = React.useState<Notification[]>([]);
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const [patientsResponse, notificationsResponse] = await Promise.all([
        supabase.from('patients').select('*'),
        supabase.from('notifications').select('*').order('created_at', { ascending: false })
      ]);

      if (patientsResponse.error) throw patientsResponse.error;
      if (notificationsResponse.error) throw notificationsResponse.error;

      setPatients(patientsResponse.data || []);
      setNotifications(notificationsResponse.data || []);
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  // Generate notifications based on payment status
  useEffect(() => {
    const generatePaymentNotifications = async () => {
      const today = new Date();
      const lastMonth = endOfMonth(subMonths(today, 1));
      const thirtyDaysAgo = subDays(today, 30);

      const overduePatients = patients.filter(patient => {
        if (!patient.is_active) return false;
        
        const lastPayment = new Date(patient.last_payment_date);
        return isAfter(thirtyDaysAgo, lastPayment);
      });

      const newNotifications: NotificationInsert[] = [];

      for (const patient of overduePatients) {
        const existingNotification = notifications.find(
          n => n.patient_id === patient.id && n.type === 'payment' && !n.is_read
        );

        if (!existingNotification) {
          const daysSincePayment = Math.floor(
            (today.getTime() - new Date(patient.last_payment_date).getTime()) / (1000 * 60 * 60 * 24)
          );

          let priority: 'low' | 'medium' | 'high' = 'low';
          if (daysSincePayment > 45) priority = 'high';
          else if (daysSincePayment > 30) priority = 'medium';

          newNotifications.push({
            patient_id: patient.id,
            message: `${patient.name} has an overdue payment (${daysSincePayment} days)`,
            type: 'payment',
            priority,
            is_read: false
          });
        }
      }

      if (newNotifications.length > 0) {
        try {
          const { error } = await supabase
            .from('notifications')
            .insert(newNotifications);

          if (error) throw error;
          await fetchData();
        } catch (error) {
          console.error('Error creating notifications:', error);
        }
      }
    };

    if (patients.length > 0) {
      generatePaymentNotifications();
    }
  }, [patients]);

  const markAsRead = async (notificationId: string) => {
    try {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('id', notificationId);

      if (error) throw error;
      await fetchData();
    } catch (error) {
      console.error('Error marking notification as read:', error);
    }
  };

  const markAllAsRead = async () => {
    try {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('is_read', false);

      if (error) throw error;
      await fetchData();
    } catch (error) {
      console.error('Error marking all notifications as read:', error);
    }
  };

  const deleteNotification = async (notificationId: string) => {
    try {
      const { error } = await supabase
        .from('notifications')
        .delete()
        .eq('id', notificationId);

      if (error) throw error;
      await fetchData();
    } catch (error) {
      console.error('Error deleting notification:', error);
    }
  };

  const getPatientName = (patientId: string) => {
    const patient = patients.find(p => p.id === patientId);
    return patient?.name || 'Unknown Patient';
  };

  const unreadNotifications = notifications.filter(n => !n.is_read);
  const readNotifications = notifications.filter(n => n.is_read);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-sky-600"></div>
      </div>
    );
  }

  const getPriorityIcon = (priority: string) => {
    switch (priority) {
      case 'high': return <AlertTriangle className="h-5 w-5 text-red-500" />;
      case 'medium': return <Clock className="h-5 w-5 text-yellow-500" />;
      case 'low': return <Bell className="h-5 w-5 text-blue-500" />;
      default: return <Bell className="h-5 w-5 text-gray-500" />;
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high': return 'border-l-red-500 bg-red-50';
      case 'medium': return 'border-l-yellow-500 bg-yellow-50';
      case 'low': return 'border-l-blue-500 bg-blue-50';
      default: return 'border-l-gray-500 bg-gray-50';
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Notification Center</h1>
          <p className="text-gray-600 mt-1">
            {unreadNotifications.length} unread notification{unreadNotifications.length !== 1 ? 's' : ''}
          </p>
        </div>
        {unreadNotifications.length > 0 && (
          <button
            onClick={markAllAsRead}
            className="bg-sky-600 hover:bg-sky-700 text-white px-4 py-2 rounded-md flex items-center space-x-2"
          >
            <CheckCircle className="h-5 w-5" />
            <span>Mark All Read</span>
          </button>
        )}
      </div>

      {/* Notification Summary */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white p-4 rounded-lg shadow border-l-4 border-l-red-500">
          <div className="flex items-center">
            <AlertTriangle className="h-6 w-6 text-red-500" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600">High Priority</p>
              <p className="text-lg font-bold text-gray-900">
                {notifications.filter(n => n.priority === 'high' && !n.is_read).length}
              </p>
            </div>
          </div>
        </div>
        <div className="bg-white p-4 rounded-lg shadow border-l-4 border-l-yellow-500">
          <div className="flex items-center">
            <Clock className="h-6 w-6 text-yellow-500" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600">Medium Priority</p>
              <p className="text-lg font-bold text-gray-900">
                {notifications.filter(n => n.priority === 'medium' && !n.is_read).length}
              </p>
            </div>
          </div>
        </div>
        <div className="bg-white p-4 rounded-lg shadow border-l-4 border-l-blue-500">
          <div className="flex items-center">
            <Bell className="h-6 w-6 text-blue-500" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600">Low Priority</p>
              <p className="text-lg font-bold text-gray-900">
                {notifications.filter(n => n.priority === 'low' && !n.is_read).length}
              </p>
            </div>
          </div>
        </div>
        <div className="bg-white p-4 rounded-lg shadow border-l-4 border-l-green-500">
          <div className="flex items-center">
            <Calendar className="h-6 w-6 text-green-500" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600">Total Notifications</p>
              <p className="text-lg font-bold text-gray-900">{notifications.length}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Unread Notifications */}
      {unreadNotifications.length > 0 && (
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
              Unread Notifications
            </h3>
            <div className="space-y-3">
              {unreadNotifications
                .sort((a, b) => {
                  const priorityOrder = { high: 3, medium: 2, low: 1 };
                  return priorityOrder[b.priority] - priorityOrder[a.priority];
                })
                .map((notification) => (
                  <div
                    key={notification.id}
                    className={`border-l-4 p-4 rounded-md ${getPriorityColor(notification.priority)}`}
                  >
                    <div className="flex items-start justify-between">
                      <div className="flex items-start space-x-3">
                        {getPriorityIcon(notification.priority)}
                        <div className="flex-1">
                          <p className="text-sm font-medium text-gray-900">
                            {notification.message}
                          </p>
                          <p className="text-xs text-gray-500 mt-1">
                            {format(new Date(notification.created_at), 'PPp')}
                          </p>
                        </div>
                      </div>
                      <div className="flex items-center space-x-2">
                        <button
                          onClick={() => markAsRead(notification.id)}
                          className="text-sm text-sky-600 hover:text-sky-700"
                        >
                          Mark Read
                        </button>
                        <button
                          onClick={() => deleteNotification(notification.id)}
                          className="text-sm text-red-600 hover:text-red-700"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
            </div>
          </div>
        </div>
      )}

      {/* Read Notifications */}
      {readNotifications.length > 0 && (
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
              Read Notifications
            </h3>
            <div className="space-y-3 max-h-96 overflow-y-auto">
              {readNotifications
                .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
                .map((notification) => (
                  <div
                    key={notification.id}
                    className="border border-gray-200 p-4 rounded-md bg-gray-50 opacity-75"
                  >
                    <div className="flex items-start justify-between">
                      <div className="flex items-start space-x-3">
                        <CheckCircle className="h-5 w-5 text-green-500" />
                        <div className="flex-1">
                          <p className="text-sm text-gray-700">
                            {notification.message}
                          </p>
                          <p className="text-xs text-gray-500 mt-1">
                            {format(new Date(notification.created_at), 'PPp')}
                          </p>
                        </div>
                      </div>
                      <button
                        onClick={() => deleteNotification(notification.id)}
                        className="text-sm text-red-600 hover:text-red-700"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                ))}
            </div>
          </div>
        </div>
      )}

      {notifications.length === 0 && (
        <div className="bg-white shadow rounded-lg p-8 text-center">
          <Bell className="h-12 w-12 text-gray-300 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">No notifications</h3>
          <p className="text-gray-500">You're all caught up! New notifications will appear here.</p>
        </div>
      )}
    </div>
  );
};

export default NotificationCenter;