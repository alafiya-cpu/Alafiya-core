/*
  # Create treatments table

  1. New Tables
    - `treatments`
      - `id` (uuid, primary key)
      - `patient_id` (uuid, foreign key to patients)
      - `date` (timestamp)
      - `treatment_given` (text)
      - `notes` (text, nullable)
      - `therapist_name` (text)
      - `created_at` (timestamp)
  2. Security
    - Enable RLS on `treatments` table
    - Add policies for authenticated users to manage treatments
*/

CREATE TABLE IF NOT EXISTS treatments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id uuid NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  date timestamptz DEFAULT now(),
  treatment_given text NOT NULL,
  notes text,
  therapist_name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE treatments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view treatments"
  ON treatments
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert treatments"
  ON treatments
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update treatments"
  ON treatments
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete treatments"
  ON treatments
  FOR DELETE
  TO authenticated
  USING (true);

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_treatments_patient_id ON treatments(patient_id);
CREATE INDEX IF NOT EXISTS idx_treatments_date ON treatments(date);