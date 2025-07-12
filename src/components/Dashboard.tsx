import React from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/supabase';
import { Users, DollarSign, AlertTriangle, UserX, Calendar, TrendingUp } from 'lucide-react';
import { format, isAfter, subDays, startOfMonth, endOfMonth } from 'date-fns';

type Patient = Database['public']['Tables']['patients']['Row'];
type Payment = Database['public']['Tables']['payments']['Row'];
type Treatment = Database['public']['Tables']['treatments']['Row'];

const Dashboard: React.FC = () => {
  const [patients, setPatients] = React.useState<Patient[]>([]);
  const [payments, setPayments] = React.useState<Payment[]>([]);
  const [treatments, setTreatments] = React.useState<Treatment[]>([]);
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const [patientsResponse, paymentsResponse, treatmentsResponse] = await Promise.all([
        supabase.from('patients').select('*'),
        supabase.from('payments').select('*'),
        supabase.from('treatments').select('*')
      ]);

      if (patientsResponse.error) throw patientsResponse.error;
      if (paymentsResponse.error) throw paymentsResponse.error;
      if (treatmentsResponse.error) throw treatmentsResponse.error;

      setPatients(patientsResponse.data || []);
      setPayments(paymentsResponse.data || []);
      setTreatments(treatmentsResponse.data || []);
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const activePatients = patients.filter(p => p.is_active);
  const dischargedPatients = patients.filter(p => !p.is_active);
  
  const currentMonth = new Date();
  const monthStart = startOfMonth(currentMonth);
  const monthEnd = endOfMonth(currentMonth);
  
  const monthlyPayments = payments.filter(p => {
    const paymentDate = new Date(p.date);
    return paymentDate >= monthStart && paymentDate <= monthEnd;
  });
  
  const totalMonthlyRevenue = monthlyPayments
    .filter(p => p.status === 'completed')
    .reduce((sum, p) => sum + p.amount, 0);
  
  const pendingPayments = patients.filter(p => {
    const lastPayment = new Date(p.last_payment_date);
    const thirtyDaysAgo = subDays(new Date(), 30);
    return p.is_active && isAfter(thirtyDaysAgo, lastPayment);
  });

  const monthlyTreatments = treatments.filter(t => {
    const treatmentDate = new Date(t.date);
    return treatmentDate >= monthStart && treatmentDate <= monthEnd;
  });

  const stats = [
    {
      title: 'Active Patients',
      value: activePatients.length,
      icon: Users,
      color: 'bg-blue-500',
      change: '+12%',
      changeType: 'positive'
    },
    {
      title: 'Monthly Revenue',
      value: `$${totalMonthlyRevenue.toLocaleString()}`,
      icon: DollarSign,
      color: 'bg-green-500',
      change: '+8%',
      changeType: 'positive'
    },
    {
      title: 'Pending Payments',
      value: pendingPayments.length,
      icon: AlertTriangle,
      color: 'bg-red-500',
      change: '-5%',
      changeType: 'negative'
    },
    {
      title: 'Total Discharges',
      value: dischargedPatients.length,
      icon: UserX,
      color: 'bg-purple-500',
      change: '+3%',
      changeType: 'positive'
    },
    {
      title: 'Monthly Treatments',
      value: monthlyTreatments.length,
      icon: Calendar,
      color: 'bg-orange-500',
      change: '+15%',
      changeType: 'positive'
    },
    {
      title: 'Average Treatment/Patient',
      value: activePatients.length > 0 ? (monthlyTreatments.length / activePatients.length).toFixed(1) : '0',
      icon: TrendingUp,
      color: 'bg-teal-500',
      change: '+7%',
      changeType: 'positive'
    }
  ];

  const recentPatients = patients
    .sort((a, b) => new Date(b.registration_date).getTime() - new Date(a.registration_date).getTime())
    .slice(0, 5);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-sky-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <div className="text-sm text-gray-500">
          Last updated: {format(new Date(), 'MMM dd, yyyy HH:mm')}
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {stats.map((stat, index) => (
          <div key={index} className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <div className={`${stat.color} p-3 rounded-md`}>
                    <stat.icon className="h-6 w-6 text-white" />
                  </div>
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">
                      {stat.title}
                    </dt>
                    <dd className="flex items-baseline">
                      <div className="text-2xl font-semibold text-gray-900">
                        {stat.value}
                      </div>
                      <div className={`ml-2 flex items-baseline text-sm font-semibold ${
                        stat.changeType === 'positive' ? 'text-green-600' : 'text-red-600'
                      }`}>
                        {stat.change}
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Patients */}
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
              Recent Patients
            </h3>
            <div className="space-y-3">
              {recentPatients.length > 0 ? (
                recentPatients.map((patient) => (
                  <div key={patient.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-md">
                    <div>
                      <p className="text-sm font-medium text-gray-900">{patient.name}</p>
                      <p className="text-xs text-gray-500">
                        Registered: {format(new Date(patient.registration_date), 'MMM dd, yyyy')}
                      </p>
                    </div>
                    <div className={`px-2 py-1 text-xs rounded-full ${
                      patient.payment_status === 'paid' 
                        ? 'bg-green-100 text-green-800'
                        : patient.payment_status === 'pending'
                        ? 'bg-yellow-100 text-yellow-800'
                        : 'bg-red-100 text-red-800'
                    }`}>
                      {patient.payment_status}
                    </div>
                  </div>
                ))
              ) : (
                <p className="text-sm text-gray-500 italic">No patients registered yet</p>
              )}
            </div>
          </div>
        </div>

        {/* Payment Alerts */}
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
              Payment Alerts
            </h3>
            <div className="space-y-3">
              {pendingPayments.length > 0 ? (
                pendingPayments.slice(0, 5).map((patient) => (
                  <div key={patient.id} className="flex items-center justify-between p-3 bg-red-50 rounded-md border border-red-200">
                    <div>
                      <p className="text-sm font-medium text-gray-900">{patient.name}</p>
                      <p className="text-xs text-red-600">
                        Last payment: {format(new Date(patient.last_payment_date), 'MMM dd, yyyy')}
                      </p>
                    </div>
                    <div className="text-xs font-medium text-red-700">
                      Overdue
                    </div>
                  </div>
                ))
              ) : (
                <p className="text-sm text-gray-500 italic">All payments are up to date</p>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Monthly Overview */}
      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
            Monthly Overview - {format(currentMonth, 'MMMM yyyy')}
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">{activePatients.length}</div>
              <div className="text-sm text-gray-500">Active Patients</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-green-600">${totalMonthlyRevenue.toLocaleString()}</div>
              <div className="text-sm text-gray-500">Revenue</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-orange-600">{monthlyTreatments.length}</div>
              <div className="text-sm text-gray-500">Treatments</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-purple-600">{dischargedPatients.length}</div>
              <div className="text-sm text-gray-500">Total Discharges</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;