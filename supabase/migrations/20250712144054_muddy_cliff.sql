/*
  # Create patients table

  1. New Tables
    - `patients`
      - `id` (uuid, primary key)
      - `name` (text)
      - `age` (integer)
      - `contact_number` (text)
      - `registration_date` (timestamp)
      - `diagnoses` (text)
      - `treatment` (text)
      - `last_payment_date` (timestamp)
      - `payment_amount` (decimal)
      - `payment_status` (text)
      - `is_active` (boolean, default true)
      - `discharge_date` (timestamp, nullable)
      - `discharge_reason` (text, nullable)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
  2. Security
    - Enable RLS on `patients` table
    - Add policies for authenticated users to manage patients
*/

CREATE TABLE IF NOT EXISTS patients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  age integer NOT NULL CHECK (age > 0),
  contact_number text NOT NULL,
  registration_date timestamptz DEFAULT now(),
  diagnoses text NOT NULL,
  treatment text NOT NULL,
  last_payment_date timestamptz DEFAULT now(),
  payment_amount decimal(10,2) NOT NULL DEFAULT 0,
  payment_status text DEFAULT 'pending' CHECK (payment_status IN ('paid', 'pending', 'overdue')),
  is_active boolean DEFAULT true,
  discharge_date timestamptz,
  discharge_reason text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view patients"
  ON patients
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert patients"
  ON patients
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update patients"
  ON patients
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete patients"
  ON patients
  FOR DELETE
  TO authenticated
  USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_patients_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();