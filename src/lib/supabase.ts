import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://ctpmrmghfqfhnuvucaca.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0cG1ybWdoZnFmaG51dnVjYWNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIzMjg1NzYsImV4cCI6MjA2NzkwNDU3Nn0.qDDoQml791uYk1cUqdVON4QVAq4XJ0UDxX3MdCugFyY';

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Database types
export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string;
          email: string;
          name: string;
          role: 'admin' | 'staff';
          created_at: string;
        };
        Insert: {
          id?: string;
          email: string;
          name: string;
          role?: 'admin' | 'staff';
          created_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          name?: string;
          role?: 'admin' | 'staff';
          created_at?: string;
        };
      };
      patients: {
        Row: {
          id: string;
          name: string;
          age: number;
          contact_number: string;
          registration_date: string;
          diagnoses: string;
          treatment: string;
          last_payment_date: string;
          payment_amount: number;
          payment_status: 'paid' | 'pending' | 'overdue';
          is_active: boolean;
          discharge_date: string | null;
          discharge_reason: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          age: number;
          contact_number: string;
          registration_date?: string;
          diagnoses: string;
          treatment: string;
          last_payment_date?: string;
          payment_amount?: number;
          payment_status?: 'paid' | 'pending' | 'overdue';
          is_active?: boolean;
          discharge_date?: string | null;
          discharge_reason?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          age?: number;
          contact_number?: string;
          registration_date?: string;
          diagnoses?: string;
          treatment?: string;
          last_payment_date?: string;
          payment_amount?: number;
          payment_status?: 'paid' | 'pending' | 'overdue';
          is_active?: boolean;
          discharge_date?: string | null;
          discharge_reason?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      treatments: {
        Row: {
          id: string;
          patient_id: string;
          date: string;
          treatment_given: string;
          notes: string | null;
          therapist_name: string;
          created_at: string;
        };
        Insert: {
          id?: string;
          patient_id: string;
          date?: string;
          treatment_given: string;
          notes?: string | null;
          therapist_name: string;
          created_at?: string;
        };
        Update: {
          id?: string;
          patient_id?: string;
          date?: string;
          treatment_given?: string;
          notes?: string | null;
          therapist_name?: string;
          created_at?: string;
        };
      };
      payments: {
        Row: {
          id: string;
          patient_id: string;
          amount: number;
          date: string;
          method: 'cash' | 'card' | 'insurance';
          status: 'completed' | 'pending' | 'failed';
          created_at: string;
        };
        Insert: {
          id?: string;
          patient_id: string;
          amount: number;
          date?: string;
          method?: 'cash' | 'card' | 'insurance';
          status?: 'completed' | 'pending' | 'failed';
          created_at?: string;
        };
        Update: {
          id?: string;
          patient_id?: string;
          amount?: number;
          date?: string;
          method?: 'cash' | 'card' | 'insurance';
          status?: 'completed' | 'pending' | 'failed';
          created_at?: string;
        };
      };
      notifications: {
        Row: {
          id: string;
          patient_id: string;
          message: string;
          type: 'payment' | 'treatment' | 'discharge';
          priority: 'low' | 'medium' | 'high';
          is_read: boolean;
          created_at: string;
        };
        Insert: {
          id?: string;
          patient_id: string;
          message: string;
          type?: 'payment' | 'treatment' | 'discharge';
          priority?: 'low' | 'medium' | 'high';
          is_read?: boolean;
          created_at?: string;
        };
        Update: {
          id?: string;
          patient_id?: string;
          message?: string;
          type?: 'payment' | 'treatment' | 'discharge';
          priority?: 'low' | 'medium' | 'high';
          is_read?: boolean;
          created_at?: string;
        };
      };
    };
  };
}