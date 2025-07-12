import React, { useEffect } from 'react';
import { useLocalStorage } from '../hooks/useLocalStorage';
import { Patient, Notification } from '../types';
import { Bell, AlertTriangle, CheckCircle, Clock, Calendar } from 'lucide-react';
import { format, isAfter, subDays, endOfMonth, subMonths } from 'date-fns';

const NotificationCenter: React.FC = () => {
  const [patients] = useLocalStorage<Patient[]>('patients', []);
  const [notifications, setNotifications] = useLocalStorage<Notification[]>('notifications', []);

  // Generate notifications based on payment status
  useEffect(() => {
    const generatePaymentNotifications = () => {
      const today = new Date();
      const lastMonth = endOfMonth(subMonths(today, 1));
      const thirtyDaysAgo = subDays(today, 30);

      const overduePatients = patients.filter(patient => {
        if (!patient.isActive) return false;
        
        const lastPayment = new Date(patient.lastPaymentDate);
        return isAfter(thirtyDaysAgo, lastPayment);
      });

      const newNotifications: Notification[] = [];

      overduePatients.forEach(patient => {
        const existingNotification = notifications.find(
          n => n.patientId === patient.id && n.type === 'payment' && !n.isRead
        );

        if (!existingNotification) {
          const daysSincePayment = Math.floor(
            (today.getTime() - new Date(patient.lastPaymentDate).getTime()) / (1000 * 60 * 60 * 24)
          );

          let priority: 'low' | 'medium' | 'high' = 'low';
          if (daysSincePayment > 45) priority = 'high';
          else if (daysSincePayment > 30) priority = 'medium';

          newNotifications.push({
            id: crypto.randomUUID(),
            patientId: patient.id,
            message: `${patient.name} has an overdue payment (${daysSincePayment} days)`,
            type: 'payment',
            priority,
            isRead: false,
            createdAt: new Date().toISOString()
          });
        }
      });

      if (newNotifications.length > 0) {
        setNotifications(prev => [...prev, ...newNotifications]);
      }
    };

    generatePaymentNotifications();
  }, [patients, notifications, setNotifications]);

  const markAsRead = (notificationId: string) => {
    setNotifications(prev => 
      prev.map(n => n.id === notificationId ? { ...n, isRead: true } : n)
    );
  };

  const markAllAsRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
  };

  const deleteNotification = (notificationId: string) => {
    setNotifications(prev => prev.filter(n => n.id !== notificationId));
  };

  const getPatientName = (patientId: string) => {
    const patient = patients.find(p => p.id === patientId);
    return patient?.name || 'Unknown Patient';
  };

  const unreadNotifications = notifications.filter(n => !n.isRead);
  const readNotifications = notifications.filter(n => n.isRead);

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
                {notifications.filter(n => n.priority === 'high' && !n.isRead).length}
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
                {notifications.filter(n => n.priority === 'medium' && !n.isRead).length}
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
                {notifications.filter(n => n.priority === 'low' && !n.isRead).length}
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
                            {format(new Date(notification.createdAt), 'PPp')}
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
                .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
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
                            {format(new Date(notification.createdAt), 'PPp')}
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