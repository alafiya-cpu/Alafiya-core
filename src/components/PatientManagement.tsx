import React, { useState } from 'react';
import { useLocalStorage } from '../hooks/useLocalStorage';
import { Patient } from '../types';
import { Plus, Search, Edit2, Eye, Filter } from 'lucide-react';
import { format } from 'date-fns';

const PatientManagement: React.FC = () => {
  const [patients, setPatients] = useLocalStorage<Patient[]>('patients', []);
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

  const filteredPatients = patients.filter(patient => {
    const matchesSearch = patient.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         patient.contactNumber.includes(searchTerm);
    const matchesStatus = filterStatus === 'all' || 
                         (filterStatus === 'active' && patient.isActive) ||
                         (filterStatus === 'discharged' && !patient.isActive);
    return matchesSearch && matchesStatus;
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const currentDate = new Date().toISOString();
    
    if (editingPatient) {
      setPatients(prev => prev.map(p => 
        p.id === editingPatient.id 
          ? {
              ...p,
              name: formData.name,
              age: parseInt(formData.age),
              contactNumber: formData.contactNumber,
              diagnoses: formData.diagnoses,
              treatment: formData.treatment,
              paymentAmount: parseFloat(formData.paymentAmount),
              paymentStatus: formData.paymentStatus
            }
          : p
      ));
    } else {
      const newPatient: Patient = {
        id: crypto.randomUUID(),
        name: formData.name,
        age: parseInt(formData.age),
        contactNumber: formData.contactNumber,
        registrationDate: currentDate,
        diagnoses: formData.diagnoses,
        treatment: formData.treatment,
        lastPaymentDate: currentDate,
        paymentAmount: parseFloat(formData.paymentAmount),
        paymentStatus: formData.paymentStatus,
        isActive: true
      };
      setPatients(prev => [...prev, newPatient]);
    }

    resetForm();
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
      contactNumber: patient.contactNumber,
      diagnoses: patient.diagnoses,
      treatment: patient.treatment,
      paymentAmount: patient.paymentAmount.toString(),
      paymentStatus: patient.paymentStatus
    });
    setEditingPatient(patient);
    setShowForm(true);
  };

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
                        <p className="text-sm text-gray-500">Age: {patient.age} | Contact: {patient.contactNumber}</p>
                      </div>
                      <div className="flex items-center space-x-2">
                        <span className={`px-2 py-1 text-xs rounded-full ${
                          patient.isActive ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                        }`}>
                          {patient.isActive ? 'Active' : 'Discharged'}
                        </span>
                        <span className={`px-2 py-1 text-xs rounded-full ${
                          patient.paymentStatus === 'paid' 
                            ? 'bg-green-100 text-green-800'
                            : patient.paymentStatus === 'pending'
                            ? 'bg-yellow-100 text-yellow-800'
                            : 'bg-red-100 text-red-800'
                        }`}>
                          {patient.paymentStatus}
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
                        Registered: {format(new Date(patient.registrationDate), 'MMM dd, yyyy')} | 
                        Last Payment: {format(new Date(patient.lastPaymentDate), 'MMM dd, yyyy')}
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