/*
  # Fix Users Table RLS Policies

  1. Security Updates
    - Drop existing restrictive policies
    - Add policy for users to insert their own profile during registration
    - Add policy for users to read their own profile
    - Add policy for users to update their own profile
    - Ensure authenticated users can manage their own data

  2. Changes
    - Allow INSERT for authenticated users creating their own profile
    - Allow SELECT for users reading their own data
    - Allow UPDATE for users modifying their own data
*/

-- Drop existing policies that might be too restrictive
DROP POLICY IF EXISTS "Users can read own data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;

-- Create new policies that allow proper user management
CREATE POLICY "Users can insert own profile"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can read own profile"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);