import React, { useState } from 'react';
import { useLocalStorage } from '../hooks/useLocalStorage';
import { Patient, Payment } from '../types';
import { Plus, DollarSign, Calendar, CreditCard, Search } from 'lucide-react';
import { format } from 'date-fns';

const PaymentManagement: React.FC = () => {
  const [patients, setPatients] = useLocalStorage<Patient[]>('patients', []);
  const [payments, setPayments] = useLocalStorage<Payment[]>('payments', []);
  const [showForm, setShowForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');

  const [formData, setFormData] = useState({
    patientId: '',
    amount: '',
    method: 'cash' as 'cash' | 'card' | 'insurance'
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    const newPayment: Payment = {
      id: crypto.randomUUID(),
      patientId: formData.patientId,
      amount: parseFloat(formData.amount),
      date: new Date().toISOString(),
      method: formData.method,
      status: 'completed'
    };

    setPayments(prev => [...prev, newPayment]);

    // Update patient's last payment date and status
    setPatients(prev => prev.map(p => 
      p.id === formData.patientId 
        ? {
            ...p,
            lastPaymentDate: new Date().toISOString(),
            paymentStatus: 'paid'
          }
        : p
    ));

    setFormData({
      patientId: '',
      amount: '',
      method: 'cash'
    });
    setShowForm(false);
  };

  const getPatientName = (patientId: string) => {
    const patient = patients.find(p => p.id === patientId);
    return patient?.name || 'Unknown Patient';
  };

  const filteredPayments = payments
    .filter(payment => {
      const patientName = getPatientName(payment.patientId).toLowerCase();
      return patientName.includes(searchTerm.toLowerCase());
    })
    .sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());

  const totalRevenue = payments
    .filter(p => p.status === 'completed')
    .reduce((sum, p) => sum + p.amount, 0);

  const thisMonthRevenue = payments
    .filter(p => {
      const paymentDate = new Date(p.date);
      const now = new Date();
      return p.status === 'completed' &&
             paymentDate.getMonth() === now.getMonth() &&
             paymentDate.getFullYear() === now.getFullYear();
    })
    .reduce((sum, p) => sum + p.amount, 0);

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-900">Payment Management</h1>
        <button
          onClick={() => setShowForm(true)}
          className="bg-sky-600 hover:bg-sky-700 text-white px-4 py-2 rounded-md flex items-center space-x-2"
        >
          <Plus className="h-5 w-5" />
          <span>Record Payment</span>
        </button>
      </div>

      {/* Payment Statistics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <DollarSign className="h-8 w-8 text-green-500" />
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-600">Total Revenue</p>
              <p className="text-2xl font-bold text-gray-900">${totalRevenue.toLocaleString()}</p>
            </div>
          </div>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <Calendar className="h-8 w-8 text-blue-500" />
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-600">This Month</p>
              <p className="text-2xl font-bold text-gray-900">${thisMonthRevenue.toLocaleString()}</p>
            </div>
          </div>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <CreditCard className="h-8 w-8 text-purple-500" />
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-600">Total Payments</p>
              <p className="text-2xl font-bold text-gray-900">{payments.length}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Search Bar */}
      <div className="bg-white p-4 rounded-lg shadow">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
          <input
            type="text"
            placeholder="Search by patient name..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10 pr-4 py-2 w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-sky-500"
          />
        </div>
      </div>

      {/* Payment Form Modal */}
      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-full max-w-lg shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-bold text-gray-900">Record Payment</h3>
              <button
                onClick={() => setShowForm(false)}
                className="text-gray-400 hover:text-gray-600"
              >
                ×
              </button>
            </div>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">Patient</label>
                <select
                  required
                  value={formData.patientId}
                  onChange={(e) => setFormData(prev => ({...prev, patientId: e.target.value}))}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                >
                  <option value="">Select Patient</option>
                  {patients.filter(p => p.isActive).map(patient => (
                    <option key={patient.id} value={patient.id}>
                      {patient.name}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Amount</label>
                <input
                  type="number"
                  step="0.01"
                  required
                  value={formData.amount}
                  onChange={(e) => setFormData(prev => ({...prev, amount: e.target.value}))}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  placeholder="0.00"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Payment Method</label>
                <select
                  value={formData.method}
                  onChange={(e) => setFormData(prev => ({...prev, method: e.target.value as any}))}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                >
                  <option value="cash">Cash</option>
                  <option value="card">Card</option>
                  <option value="insurance">Insurance</option>
                </select>
              </div>
              <div className="flex justify-end space-x-3">
                <button
                  type="button"
                  onClick={() => setShowForm(false)}
                  className="px-4 py-2 text-gray-700 bg-gray-200 rounded-md hover:bg-gray-300"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700"
                >
                  Record Payment
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Payments List */}
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">Payment History</h3>
          <div className="space-y-4">
            {filteredPayments.length > 0 ? (
              filteredPayments.map((payment) => (
                <div key={payment.id} className="border border-gray-200 rounded-lg p-4 hover:bg-gray-50">
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center space-x-4">
                        <div>
                          <p className="text-lg font-medium text-gray-900">
                            {getPatientName(payment.patientId)}
                          </p>
                          <p className="text-sm text-gray-500">
                            {format(new Date(payment.date), 'PPP')} at {format(new Date(payment.date), 'p')}
                          </p>
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center space-x-4">
                      <div className="text-right">
                        <p className="text-lg font-bold text-green-600">
                          ${payment.amount.toFixed(2)}
                        </p>
                        <p className="text-sm text-gray-500 capitalize">
                          {payment.method}
                        </p>
                      </div>
                      <div className={`px-3 py-1 text-xs rounded-full ${
                        payment.status === 'completed'
                          ? 'bg-green-100 text-green-800'
                          : payment.status === 'pending'
                          ? 'bg-yellow-100 text-yellow-800'
                          : 'bg-red-100 text-red-800'
                      }`}>
                        {payment.status}
                      </div>
                    </div>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-500">
                No payments recorded yet
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PaymentManagement;