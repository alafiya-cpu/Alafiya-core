import React, { useState } from 'react';
import { useLocalStorage } from '../hooks/useLocalStorage';
import { Patient } from '../types';
import { UserX, Calendar, FileText, Search } from 'lucide-react';
import { format } from 'date-fns';

const DischargeManagement: React.FC = () => {
  const [patients, setPatients] = useLocalStorage<Patient[]>('patients', []);
  const [showForm, setShowForm] = useState(false);
  const [selectedPatient, setSelectedPatient] = useState<Patient | null>(null);
  const [searchTerm, setSearchTerm] = useState('');

  const [formData, setFormData] = useState({
    dischargeReason: '',
    notes: ''
  });

  const activePatients = patients.filter(p => p.isActive);
  const dischargedPatients = patients.filter(p => !p.isActive);

  const filteredActivePatients = activePatients.filter(patient =>
    patient.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    patient.contactNumber.includes(searchTerm)
  );

  const filteredDischargedPatients = dischargedPatients.filter(patient =>
    patient.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    patient.contactNumber.includes(searchTerm)
  );

  const handleDischarge = (patient: Patient) => {
    setSelectedPatient(patient);
    setShowForm(true);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!selectedPatient) return;

    setPatients(prev => prev.map(p => 
      p.id === selectedPatient.id 
        ? {
            ...p,
            isActive: false,
            dischargeDate: new Date().toISOString(),
            dischargeReason: formData.dischargeReason
          }
        : p
    ));

    setFormData({
      dischargeReason: '',
      notes: ''
    });
    setShowForm(false);
    setSelectedPatient(null);
  };

  const reactivatePatient = (patientId: string) => {
    setPatients(prev => prev.map(p => 
      p.id === patientId 
        ? {
            ...p,
            isActive: true,
            dischargeDate: undefined,
            dischargeReason: undefined
          }
        : p
    ));
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-900">Discharge Management</h1>
        <div className="text-sm text-gray-500">
          Active: {activePatients.length} | Discharged: {dischargedPatients.length}
        </div>
      </div>

      {/* Statistics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <UserX className="h-8 w-8 text-blue-500" />
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-600">Active Patients</p>
              <p className="text-2xl font-bold text-gray-900">{activePatients.length}</p>
            </div>
          </div>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <Calendar className="h-8 w-8 text-green-500" />
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-600">Total Discharges</p>
              <p className="text-2xl font-bold text-gray-900">{dischargedPatients.length}</p>
            </div>
          </div>
        </div>
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center">
            <FileText className="h-8 w-8 text-purple-500" />
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-600">This Month</p>
              <p className="text-2xl font-bold text-gray-900">
                {dischargedPatients.filter(p => {
                  if (!p.dischargeDate) return false;
                  const dischargeDate = new Date(p.dischargeDate);
                  const now = new Date();
                  return dischargeDate.getMonth() === now.getMonth() &&
                         dischargeDate.getFullYear() === now.getFullYear();
                }).length}
              </p>
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
            placeholder="Search patients..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10 pr-4 py-2 w-full border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-sky-500"
          />
        </div>
      </div>

      {/* Discharge Form Modal */}
      {showForm && selectedPatient && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-full max-w-lg shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-bold text-gray-900">
                Discharge Patient: {selectedPatient.name}
              </h3>
              <button
                onClick={() => setShowForm(false)}
                className="text-gray-400 hover:text-gray-600"
              >
                ×
              </button>
            </div>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700">Discharge Reason</label>
                <select
                  required
                  value={formData.dischargeReason}
                  onChange={(e) => setFormData(prev => ({...prev, dischargeReason: e.target.value}))}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                >
                  <option value="">Select reason</option>
                  <option value="treatment-completed">Treatment Completed</option>
                  <option value="patient-request">Patient Request</option>
                  <option value="medical-referral">Medical Referral</option>
                  <option value="insurance-issues">Insurance Issues</option>
                  <option value="non-compliance">Non-compliance</option>
                  <option value="other">Other</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Additional Notes</label>
                <textarea
                  value={formData.notes}
                  onChange={(e) => setFormData(prev => ({...prev, notes: e.target.value}))}
                  rows={4}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  placeholder="Any additional notes about the discharge..."
                />
              </div>
              <div className="bg-yellow-50 border border-yellow-200 p-3 rounded-md">
                <p className="text-sm text-yellow-800">
                  <strong>Warning:</strong> This action will mark the patient as discharged. 
                  You can reactivate them later if needed.
                </p>
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
                  className="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700"
                >
                  Discharge Patient
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Active Patients */}
      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">Active Patients</h3>
          <div className="space-y-4">
            {filteredActivePatients.length > 0 ? (
              filteredActivePatients.map((patient) => (
                <div key={patient.id} className="border border-gray-200 rounded-lg p-4 hover:bg-gray-50">
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="text-lg font-medium text-gray-900">{patient.name}</h4>
                        <div className="flex items-center space-x-2">
                          <span className="px-2 py-1 text-xs rounded-full bg-green-100 text-green-800">
                            Active
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
                      <p className="text-sm text-gray-600">
                        Age: {patient.age} | Contact: {patient.contactNumber}
                      </p>
                      <p className="text-sm text-gray-600">
                        Diagnosis: {patient.diagnoses}
                      </p>
                      <p className="text-sm text-gray-500">
                        Registered: {format(new Date(patient.registrationDate), 'MMM dd, yyyy')}
                      </p>
                    </div>
                    <button
                      onClick={() => handleDischarge(patient)}
                      className="ml-4 bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md flex items-center space-x-2"
                    >
                      <UserX className="h-4 w-4" />
                      <span>Discharge</span>
                    </button>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-500">
                {searchTerm ? 'No active patients found matching your search' : 'No active patients'}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Discharged Patients */}
      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">Discharged Patients</h3>
          <div className="space-y-4">
            {filteredDischargedPatients.length > 0 ? (
              filteredDischargedPatients.map((patient) => (
                <div key={patient.id} className="border border-gray-200 rounded-lg p-4 bg-gray-50">
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="text-lg font-medium text-gray-700">{patient.name}</h4>
                        <div className="flex items-center space-x-2">
                          <span className="px-2 py-1 text-xs rounded-full bg-gray-100 text-gray-800">
                            Discharged
                          </span>
                        </div>
                      </div>
                      <p className="text-sm text-gray-600">
                        Age: {patient.age} | Contact: {patient.contactNumber}
                      </p>
                      <p className="text-sm text-gray-600">
                        Diagnosis: {patient.diagnoses}
                      </p>
                      <div className="mt-2 space-y-1">
                        <p className="text-sm text-gray-500">
                          Discharged: {patient.dischargeDate ? format(new Date(patient.dischargeDate), 'MMM dd, yyyy') : 'N/A'}
                        </p>
                        {patient.dischargeReason && (
                          <p className="text-sm text-gray-500">
                            Reason: {patient.dischargeReason.replace('-', ' ').replace(/\b\w/g, l => l.toUpperCase())}
                          </p>
                        )}
                      </div>
                    </div>
                    <button
                      onClick={() => reactivatePatient(patient.id)}
                      className="ml-4 bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm"
                    >
                      Reactivate
                    </button>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-500">
                {searchTerm ? 'No discharged patients found matching your search' : 'No discharged patients'}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default DischargeManagement;