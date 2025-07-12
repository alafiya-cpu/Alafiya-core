import React, { useState } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/supabase';
import { Plus, Search, Edit2, Eye, Filter } from 'lucide-react';
import { format } from 'date-fns';

type Patient = Database['public']['Tables']['patients']['Row'];
type PatientInsert = Database['public']['Tables']['patients']['Insert'];
type PatientUpdate = Database['public']['Tables']['patients']['Update'];

const PatientManagement: React.FC = () => {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingPatient, setEditingPatient] = useState<Patient | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState<'all' | 'active' | 'discharged'>('all');

  const [formData, setFormData] = useState({
    name: '',
    age: '',
    contactNumber: '',
    diagnoses: '',
    treatment: '',
    paymentAmount: '',
    paymentStatus: 'pending' as 'paid' | 'pending' | 'overdue'
  });

  // Fetch patients on component mount
  React.useEffect(() => {
    fetchPatients();
  }, []);

  const fetchPatients = async () => {
    try {
      const { data, error } = await supabase
        .from('patients')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setPatients(data || []);
    } catch (error) {
      console.error('Error fetching patients:', error);
    } finally {
      setLoading(false);
    }
  };

  const filteredPatients = patients.filter(patient => {
    const matchesSearch = patient.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         patient.contact_number.includes(searchTerm);
    const matchesStatus = filterStatus === 'all' || 
                         (filterStatus === 'active' && patient.is_active) ||
                         (filterStatus === 'discharged' && !patient.is_active);
    return matchesSearch && matchesStatus;
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    try {
      if (editingPatient) {
        const updateData: PatientUpdate = {
          name: formData.name,
          age: parseInt(formData.age),
          contact_number: formData.contactNumber,
          diagnoses: formData.diagnoses,
          treatment: formData.treatment,
          payment_amount: parseFloat(formData.paymentAmount),
          payment_status: formData.paymentStatus
        };

        const { error } = await supabase
          .from('patients')
          .update(updateData)
          .eq('id', editingPatient.id);

        if (error) throw error;
      } else {
        const insertData: PatientInsert = {
          name: formData.name,
          age: parseInt(formData.age),
          contact_number: formData.contactNumber,
          diagnoses: formData.diagnoses,
          treatment: formData.treatment,
          payment_amount: parseFloat(formData.paymentAmount),
          payment_status: formData.paymentStatus,
          is_active: true
        };

        const { error } = await supabase
          .from('patients')
          .insert(insertData);

        if (error) throw error;
      }

      await fetchPatients();
      resetForm();
    } catch (error) {
      console.error('Error saving patient:', error);
    } finally {
      setLoading(false);
    }
  };

  const resetForm = () => {
    setFormData({
      name: '',
      age: '',
      contactNumber: '',
      diagnoses: '',
      treatment: '',
      paymentAmount: '',
      paymentStatus: 'pending'
    });
    setShowForm(false);
    setEditingPatient(null);
  };

  const handleEdit = (patient: Patient) => {
    setFormData({
      name: patient.name,
      age: patient.age.toString(),
      contactNumber: patient.contact_number,
      diagnoses: patient.diagnoses,
      treatment: patient.treatment,
      paymentAmount: patient.payment_amount.toString(),
      paymentStatus: patient.payment_status
    });
    setEditingPatient(patient);
    setShowForm(true);
  };

  if (loading && patients.length === 0) {
    return (
      <div className="flex items-center justify-center min-h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-sky-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-900">Patient Management</h1>
        <button
          onClick={() => setShowForm(true)}
          className="bg-sky-600 hover:bg-sky-700 text-white px-4 py-2 rounded-md flex items-center space-x-2"
        >
          <Plus className="h-5 w-5" />
          <span>Add Patient</span>
        </button>
      </div>

      {/* Search and Filter */}
      <div className="bg-white p-4 rounded-lg shadow space-y-4 sm:space-y-0 sm:flex sm:items-center sm:space-x-4">
        <div className="flex-1">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
            <input
              type="text"
              placeholder="Search patients..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 pr-4 py-2 w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-sky-500"
            />
          </div>
        </div>
        <div className="flex items-center space-x-2">
          <Filter className="h-5 w-5 text-gray-400" />
          <select
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value as any)}
            className="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
          >
            <option value="all">All Patients</option>
            <option value="active">Active</option>
            <option value="discharged">Discharged</option>
          </select>
        </div>
      </div>

      {/* Patient Registration Form */}
      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-full max-w-2xl shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-bold text-gray-900">
                {editingPatient ? 'Edit Patient' : 'Register New Patient'}
              </h3>
              <button
                onClick={resetForm}
                className="text-gray-400 hover:text-gray-600"
              >
                ×
              </button>
            </div>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700">Patient Name</label>
                  <input
                    type="text"
                    required
                    value={formData.name}
                    onChange={(e) => setFormData(prev => ({...prev, name: e.target.value}))}
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Age</label>
                  <input
                    type="number"
                    required
                    value={formData.age}
                    onChange={(e) => setFormData(prev => ({...prev, age: e.target.value}))}
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Contact Number</label>
                  <input
                    type="tel"
                    required
                    value={formData.contactNumber}
                    onChange={(e) => setFormData(prev => ({...prev, contactNumber: e.target.value}))}
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Payment Amount</label>
                  <input
                    type="number"
                    step="0.01"
                    required
                    value={formData.paymentAmount}
                    onChange={(e) => setFormData(prev => ({...prev, paymentAmount: e.target.value}))}
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Diagnoses</label>
                <textarea
                  required
                  value={formData.diagnoses}
                  onChange={(e) => setFormData(prev => ({...prev, diagnoses: e.target.value}))}
                  rows={3}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Treatment Plan</label>
                <textarea
                  required
                  value={formData.treatment}
                  onChange={(e) => setFormData(prev => ({...prev, treatment: e.target.value}))}
                  rows={3}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Payment Status</label>
                <select
                  value={formData.paymentStatus}
                  onChange={(e) => setFormData(prev => ({...prev, paymentStatus: e.target.value as any}))}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                >
                  <option value="pending">Pending</option>
                  <option value="paid">Paid</option>
                  <option value="overdue">Overdue</option>
                </select>
              </div>
              <div className="flex justify-end space-x-3">
                <button
                  type="button"
                  onClick={resetForm}
                  className="px-4 py-2 text-gray-700 bg-gray-200 rounded-md hover:bg-gray-300"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700"
                >
                  {editingPatient ? 'Update Patient' : 'Register Patient'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Patients List */}
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {filteredPatients.length > 0 ? (
            filteredPatients.map((patient) => (
              <li key={patient.id} className="px-6 py-4 hover:bg-gray-50">
                <div className="flex items-center justify-between">
                  <div className="flex-1">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-lg font-medium text-gray-900">{patient.name}</p>
                        <p className="text-sm text-gray-500">Age: {patient.age} | Contact: {patient.contact_number}</p>
                      </div>
                      <div className="flex items-center space-x-2">
                        <span className={`px-2 py-1 text-xs rounded-full ${
                          patient.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                        }`}>
                          {patient.is_active ? 'Active' : 'Discharged'}
                        </span>
                        <span className={`px-2 py-1 text-xs rounded-full ${
                          patient.payment_status === 'paid' 
                            ? 'bg-green-100 text-green-800'
                            : patient.payment_status === 'pending'
                            ? 'bg-yellow-100 text-yellow-800'
                            : 'bg-red-100 text-red-800'
                        }`}>
                          {patient.payment_status}
                        </span>
                      </div>
                    </div>
                    <div className="mt-2">
                      <p className="text-sm text-gray-600">
                        <strong>Diagnosis:</strong> {patient.diagnoses}
                      </p>
                      <p className="text-sm text-gray-600 mt-1">
                        <strong>Treatment:</strong> {patient.treatment}
                      </p>
                      <p className="text-sm text-gray-500 mt-1">
                        Registered: {format(new Date(patient.registration_date), 'MMM dd, yyyy')} | 
                        Last Payment: {format(new Date(patient.last_payment_date), 'MMM dd, yyyy')}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center space-x-2 ml-4">
                    <button
                      onClick={() => handleEdit(patient)}
                      className="p-2 text-gray-400 hover:text-sky-600"
                    >
                      <Edit2 className="h-5 w-5" />
                    </button>
                  </div>
                </div>
              </li>
            ))
          ) : (
            <li className="px-6 py-8 text-center text-gray-500">
              No patients found
            </li>
          )}
        </ul>
      </div>
    </div>
  );
};

export default PatientManagement;