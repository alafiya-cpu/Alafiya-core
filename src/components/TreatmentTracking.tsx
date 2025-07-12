import React, { useState } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/supabase';
import { Plus, Calendar, User, FileText } from 'lucide-react';
import { format } from 'date-fns';

type Patient = Database['public']['Tables']['patients']['Row'];
type Treatment = Database['public']['Tables']['treatments']['Row'];
type TreatmentInsert = Database['public']['Tables']['treatments']['Insert'];

const TreatmentTracking: React.FC = () => {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [treatments, setTreatments] = useState<Treatment[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [selectedPatient, setSelectedPatient] = useState('');

  const [formData, setFormData] = useState({
    patientId: '',
    treatmentGiven: '',
    notes: '',
    therapistName: ''
  });

  React.useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const [patientsResponse, treatmentsResponse] = await Promise.all([
        supabase.from('patients').select('*').eq('is_active', true),
        supabase.from('treatments').select('*').order('date', { ascending: false })
      ]);

      if (patientsResponse.error) throw patientsResponse.error;
      if (treatmentsResponse.error) throw treatmentsResponse.error;

      setPatients(patientsResponse.data || []);
      setTreatments(treatmentsResponse.data || []);
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const activePatients = patients.filter(p => p.is_active);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    try {
      const insertData: TreatmentInsert = {
        patient_id: formData.patientId,
        treatment_given: formData.treatmentGiven,
        notes: formData.notes,
        therapist_name: formData.therapistName
      };

      const { error } = await supabase
        .from('treatments')
        .insert(insertData);

      if (error) throw error;

      await fetchData();
      setFormData({
        patientId: '',
        treatmentGiven: '',
        notes: '',
        therapistName: ''
      });
      setShowForm(false);
    } catch (error) {
      console.error('Error saving treatment:', error);
    } finally {
      setLoading(false);
    }
  };

  const getPatientTreatments = (patientId: string) => {
    return treatments
      .filter(t => t.patient_id === patientId)
      .sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
  };

  const getPatientName = (patientId: string) => {
    const patient = patients.find(p => p.id === patientId);
    return patient?.name || 'Unknown Patient';
  };

  const selectedPatientTreatments = selectedPatient 
    ? getPatientTreatments(selectedPatient)
    : treatments.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()).slice(0, 10);

  if (loading && treatments.length === 0) {
    return (
      <div className="flex items-center justify-center min-h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-sky-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold text-gray-900">Treatment Tracking</h1>
        <button
          onClick={() => setShowForm(true)}
          className="bg-sky-600 hover:bg-sky-700 text-white px-4 py-2 rounded-md flex items-center space-x-2"
        >
          <Plus className="h-5 w-5" />
          <span>Record Treatment</span>
        </button>
      </div>

      {/* Patient Filter */}
      <div className="bg-white p-4 rounded-lg shadow">
        <div className="flex items-center space-x-4">
          <User className="h-5 w-5 text-gray-400" />
          <select
            value={selectedPatient}
            onChange={(e) => setSelectedPatient(e.target.value)}
            className="flex-1 border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
          >
            <option value="">All Patients (Recent Treatments)</option>
            {activePatients.map(patient => (
              <option key={patient.id} value={patient.id}>
                {patient.name}
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* Treatment Form Modal */}
      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-full max-w-2xl shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-bold text-gray-900">Record Treatment</h3>
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
                  {activePatients.map(patient => (
                    <option key={patient.id} value={patient.id}>
                      {patient.name}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Treatment Given</label>
                <textarea
                  required
                  value={formData.treatmentGiven}
                  onChange={(e) => setFormData(prev => ({...prev, treatmentGiven: e.target.value}))}
                  rows={3}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  placeholder="Describe the treatment provided..."
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Therapist Name</label>
                <input
                  type="text"
                  required
                  value={formData.therapistName}
                  onChange={(e) => setFormData(prev => ({...prev, therapistName: e.target.value}))}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  placeholder="Name of therapist"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">Notes</label>
                <textarea
                  value={formData.notes}
                  onChange={(e) => setFormData(prev => ({...prev, notes: e.target.value}))}
                  rows={3}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-sky-500"
                  placeholder="Additional notes or observations..."
                />
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
                  disabled={loading}
                  className="px-4 py-2 bg-sky-600 text-white rounded-md hover:bg-sky-700 disabled:opacity-50"
                >
                  Record Treatment
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Treatment History */}
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
            {selectedPatient 
              ? `Treatment History - ${getPatientName(selectedPatient)}`
              : 'Recent Treatments (All Patients)'
            }
          </h3>
          <div className="space-y-4">
            {selectedPatientTreatments.length > 0 ? (
              selectedPatientTreatments.map((treatment) => (
                <div key={treatment.id} className="border border-gray-200 rounded-lg p-4 hover:bg-gray-50">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center space-x-2 mb-2">
                        <Calendar className="h-4 w-4 text-gray-400" />
                        <span className="text-sm font-medium text-gray-900">
                          {format(new Date(treatment.date), 'PPP')}
                        </span>
                        <span className="text-sm text-gray-500">
                          at {format(new Date(treatment.date), 'p')}
                        </span>
                      </div>
                      {!selectedPatient && (
                        <div className="flex items-center space-x-2 mb-2">
                          <User className="h-4 w-4 text-gray-400" />
                          <span className="text-sm font-medium text-sky-600">
                            {getPatientName(treatment.patient_id)}
                          </span>
                        </div>
                      )}
                      <div className="mb-2">
                        <p className="text-sm text-gray-700">
                          <strong>Treatment:</strong> {treatment.treatment_given}
                        </p>
                      </div>
                      {treatment.notes && (
                        <div className="mb-2">
                          <p className="text-sm text-gray-600">
                            <strong>Notes:</strong> {treatment.notes}
                          </p>
                        </div>
                      )}
                      <div className="flex items-center space-x-2">
                        <FileText className="h-4 w-4 text-gray-400" />
                        <span className="text-sm text-gray-500">
                          Therapist: {treatment.therapist_name}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-500">
                {selectedPatient 
                  ? 'No treatments recorded for this patient yet'
                  : 'No treatments recorded yet'
                }
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Treatment Statistics */}
      {selectedPatient && (
        <div className="bg-white shadow rounded-lg p-6">
          <h3 className="text-lg font-medium text-gray-900 mb-4">Treatment Statistics</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-sky-600">
                {getPatientTreatments(selectedPatient).length}
              </div>
              <div className="text-sm text-gray-500">Total Treatments</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-green-600">
                {getPatientTreatments(selectedPatient).filter(t => 
                  new Date(t.date) >= new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
                ).length}
              </div>
              <div className="text-sm text-gray-500">Last 30 Days</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-purple-600">
                {getPatientTreatments(selectedPatient).filter(t => 
                  new Date(t.date) >= new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
                ).length}
              </div>
              <div className="text-sm text-gray-500">This Week</div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TreatmentTracking;