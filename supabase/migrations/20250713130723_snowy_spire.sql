/*
  # Comprehensive fix for user access and RLS issues

  1. Security Changes
    - Drop existing restrictive RLS policies on users table
    - Create new policies that properly handle user authentication
    - Use auth.uid() function correctly for user identification
    - Add policy for user registration (INSERT)
    - Add policy for profile access (SELECT)
    - Add policy for profile updates (UPDATE)

  2. Data Integrity
    - Ensure users can create and access their own profiles
    - Fix authentication flow issues
*/

-- Drop existing policies that are causing issues
DROP POLICY IF EXISTS "Users can read own data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;

-- Create new comprehensive policies for users table
CREATE POLICY "Enable insert for authenticated users during registration"
  ON users
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Enable read access for users to their own profile"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Enable update for users to their own profile"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Ensure RLS is enabled
ALTER TABLE users ENABLE ROW LEVEL SECURITY;