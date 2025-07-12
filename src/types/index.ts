export interface User {
  id: string;
  email: string;
  password: string;
  name: string;
  role: 'admin' | 'staff';
  createdAt: string;
}

export interface Patient {
  id: string;
  name: string;
  age: number;
  contactNumber: string;
  registrationDate: string;
  diagnoses: string;
  treatment: string;
  lastPaymentDate: string;
  paymentAmount: number;
  paymentStatus: 'paid' | 'pending' | 'overdue';
  isActive: boolean;
  dischargeDate?: string;
  dischargeReason?: string;
}

export interface Treatment {
  id: string;
  patientId: string;
  date: string;
  treatmentGiven: string;
  notes: string;
  therapistName: string;
}

export interface Payment {
  id: string;
  patientId: string;
  amount: number;
  date: string;
  method: 'cash' | 'card' | 'insurance';
  status: 'completed' | 'pending' | 'failed';
}

export interface Notification {
  id: string;
  patientId: string;
  message: string;
  type: 'payment' | 'treatment' | 'discharge';
  priority: 'low' | 'medium' | 'high';
  isRead: boolean;
  createdAt: string;
}