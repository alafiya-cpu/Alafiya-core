import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
const supabaseServiceRoleKey = import.meta.env.VITE_SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

// Regular client for authenticated operations
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Service role client for admin operations (demo mode)
export const supabaseAdmin = supabaseServiceRoleKey
  ? createClient(supabaseUrl, supabaseServiceRoleKey)
  : null;

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
          last_login_at?: string;
          login_attempts?: number;
          locked_until?: string;
          email_verified?: boolean;
          oauth_provider?: string;
          oauth_id?: string;
          updated_at?: string;
        };
        Insert: {
          id?: string;
          email: string;
          name: string;
          role?: 'admin' | 'staff';
          created_at?: string;
          last_login_at?: string;
          login_attempts?: number;
          locked_until?: string;
          email_verified?: boolean;
          oauth_provider?: string;
          oauth_id?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          name?: string;
          role?: 'admin' | 'staff';
          created_at?: string;
          last_login_at?: string;
          login_attempts?: number;
          locked_until?: string;
          email_verified?: boolean;
          oauth_provider?: string;
          oauth_id?: string;
          updated_at?: string;
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