/*
  # Enhanced Authentication Security Migration

  1. Add Google OAuth provider configuration
  2. Update RLS policies for proper admin/staff access control
  3. Add security enhancements for authentication
  4. Create rate limiting table for auth attempts
  5. Add CSRF protection mechanisms
  6. Enhance user profile management
*/

-- Enable Google OAuth provider
INSERT INTO auth.providers (provider_id, provider_name, enabled)
VALUES ('google', 'google', true)
ON CONFLICT (provider_id) DO UPDATE SET enabled = true;

-- Create rate limiting table for authentication attempts
CREATE TABLE IF NOT EXISTS auth_rate_limits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  identifier text NOT NULL, -- IP address or user identifier
  action text NOT NULL, -- 'login', 'register', 'oauth'
  attempts integer DEFAULT 1,
  first_attempt timestamptz DEFAULT now(),
  last_attempt timestamptz DEFAULT now(),
  blocked_until timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Create indexes for rate limiting
CREATE INDEX IF NOT EXISTS idx_auth_rate_limits_identifier_action ON auth_rate_limits(identifier, action);
CREATE INDEX IF NOT EXISTS idx_auth_rate_limits_blocked_until ON auth_rate_limits(blocked_until);

-- Create function to check rate limits
CREATE OR REPLACE FUNCTION check_auth_rate_limit(
  p_identifier text,
  p_action text,
  p_max_attempts integer DEFAULT 5,
  p_window_minutes integer DEFAULT 15,
  p_block_minutes integer DEFAULT 30
) RETURNS boolean AS $$
DECLARE
  v_record auth_rate_limits%ROWTYPE;
  v_attempts integer;
BEGIN
  -- Get current rate limit record
  SELECT * INTO v_record
  FROM auth_rate_limits
  WHERE identifier = p_identifier AND action = p_action
  ORDER BY last_attempt DESC
  LIMIT 1;

  -- Check if currently blocked
  IF v_record.blocked_until IS NOT NULL AND v_record.blocked_until > now() THEN
    RETURN false;
  END IF;

  -- Count attempts in the window
  SELECT COUNT(*) INTO v_attempts
  FROM auth_rate_limits
  WHERE identifier = p_identifier
    AND action = p_action
    AND last_attempt > now() - interval '1 minute' * p_window_minutes;

  -- If too many attempts, block
  IF v_attempts >= p_max_attempts THEN
    UPDATE auth_rate_limits
    SET blocked_until = now() + interval '1 minute' * p_block_minutes,
        last_attempt = now()
    WHERE identifier = p_identifier AND action = p_action;

    -- Insert new record if none exists
    INSERT INTO auth_rate_limits (identifier, action, attempts, blocked_until)
    VALUES (p_identifier, p_action, v_attempts + 1, now() + interval '1 minute' * p_block_minutes)
    ON CONFLICT DO NOTHING;

    RETURN false;
  END IF;

  -- Log the attempt
  INSERT INTO auth_rate_limits (identifier, action, attempts)
  VALUES (p_identifier, p_action, 1)
  ON CONFLICT (id) DO UPDATE SET
    attempts = auth_rate_limits.attempts + 1,
    last_attempt = now();

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create CSRF token table
CREATE TABLE IF NOT EXISTS auth_csrf_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  token text UNIQUE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  session_id text,
  expires_at timestamptz NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create index for CSRF tokens
CREATE INDEX IF NOT EXISTS idx_auth_csrf_tokens_token ON auth_csrf_tokens(token);
CREATE INDEX IF NOT EXISTS idx_auth_csrf_tokens_expires_at ON auth_csrf_tokens(expires_at);

-- Create function to generate CSRF token
CREATE OR REPLACE FUNCTION generate_csrf_token(p_user_id uuid DEFAULT NULL, p_session_id text DEFAULT NULL)
RETURNS text AS $$
DECLARE
  v_token text;
BEGIN
  -- Generate a secure random token
  v_token := encode(gen_random_bytes(32), 'hex');

  -- Store the token
  INSERT INTO auth_csrf_tokens (token, user_id, session_id, expires_at)
  VALUES (v_token, p_user_id, p_session_id, now() + interval '1 hour');

  RETURN v_token;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to validate CSRF token
CREATE OR REPLACE FUNCTION validate_csrf_token(p_token text, p_user_id uuid DEFAULT NULL)
RETURNS boolean AS $$
DECLARE
  v_valid boolean := false;
BEGIN
  -- Check if token exists and is not expired
  SELECT EXISTS(
    SELECT 1 FROM auth_csrf_tokens
    WHERE token = p_token
      AND (user_id = p_user_id OR user_id IS NULL)
      AND expires_at > now()
  ) INTO v_valid;

  -- Delete used token
  IF v_valid THEN
    DELETE FROM auth_csrf_tokens WHERE token = p_token;
  END IF;

  RETURN v_valid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add additional security fields to users table
ALTER TABLE users
ADD COLUMN IF NOT EXISTS last_login_at timestamptz,
ADD COLUMN IF NOT EXISTS login_attempts integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS locked_until timestamptz,
ADD COLUMN IF NOT EXISTS email_verified boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS oauth_provider text,
ADD COLUMN IF NOT EXISTS oauth_id text,
ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT now();

-- Create indexes for security fields
CREATE INDEX IF NOT EXISTS idx_users_oauth_provider_id ON users(oauth_provider, oauth_id);
CREATE INDEX IF NOT EXISTS idx_users_locked_until ON users(locked_until);

-- Update RLS policies for enhanced security

-- Drop existing policies
DROP POLICY IF EXISTS "Users can insert own profile" ON users;
DROP POLICY IF EXISTS "Users can read own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users during registration" ON users;
DROP POLICY IF EXISTS "Enable read access for users to their own profile" ON users;
DROP POLICY IF EXISTS "Enable update for users to their own profile" ON users;

-- Create new comprehensive policies
CREATE POLICY "users_insert_policy" ON users
  FOR INSERT TO authenticated
  WITH CHECK (
    -- Allow users to create their own profile during registration
    auth.uid() = id
    -- Allow admins to create any user
    OR EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "users_select_policy" ON users
  FOR SELECT TO authenticated
  USING (
    -- Users can read their own profile
    auth.uid() = id
    -- Admins can read all profiles
    OR EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
    -- Staff can read their own profile only
    OR (EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'staff'
    ) AND auth.uid() = id)
  );

CREATE POLICY "users_update_policy" ON users
  FOR UPDATE TO authenticated
  USING (
    -- Users can update their own profile
    auth.uid() = id
    -- Admins can update any profile
    OR EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  )
  WITH CHECK (
    -- Users can update their own profile
    auth.uid() = id
    -- Admins can update any profile
    OR EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Create admin policy for user management
CREATE POLICY "admin_manage_users" ON users
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Update patient policies for role-based access
DROP POLICY IF EXISTS "Authenticated users can view patients" ON patients;
DROP POLICY IF EXISTS "Authenticated users can insert patients" ON patients;
DROP POLICY IF EXISTS "Authenticated users can update patients" ON patients;
DROP POLICY IF EXISTS "Authenticated users can delete patients" ON patients;

CREATE POLICY "patients_admin_full_access" ON patients
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "patients_staff_crud" ON patients
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role IN ('admin', 'staff')
    )
  );

CREATE POLICY "patients_staff_insert" ON patients
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid() AND role IN ('admin', 'staff')
    )
  );

-- Staff cannot update or delete patients (only view and create)
-- Admin has full access as defined above

-- Create function to handle Google OAuth user creation
CREATE OR REPLACE FUNCTION handle_google_oauth_user()
RETURNS trigger AS $$
BEGIN
  -- Only process if this is a Google OAuth signup
  IF NEW.raw_user_meta_data->>'provider' = 'google' THEN
    -- Insert or update user profile
    INSERT INTO users (id, email, name, role, oauth_provider, oauth_id, email_verified, updated_at)
    VALUES (
      NEW.id,
      NEW.email,
      COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
      'staff', -- Default role for OAuth users
      'google',
      NEW.raw_user_meta_data->>'sub',
      true,
      now()
    )
    ON CONFLICT (id) DO UPDATE SET
      email = EXCLUDED.email,
      name = EXCLUDED.name,
      oauth_provider = EXCLUDED.oauth_provider,
      oauth_id = EXCLUDED.oauth_id,
      email_verified = EXCLUDED.email_verified,
      updated_at = now();

    -- Update last login
    UPDATE users SET last_login_at = now() WHERE id = NEW.id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for Google OAuth user handling
DROP TRIGGER IF EXISTS on_auth_user_created_google ON auth.users;
CREATE TRIGGER on_auth_user_created_google
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_google_oauth_user();

-- Create function to update last login on sign in
CREATE OR REPLACE FUNCTION update_last_login()
RETURNS trigger AS $$
BEGIN
  UPDATE users SET last_login_at = now() WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for login tracking
DROP TRIGGER IF EXISTS on_auth_session_created ON auth.sessions;
CREATE TRIGGER on_auth_session_created
  AFTER INSERT ON auth.sessions
  FOR EACH ROW EXECUTE FUNCTION update_last_login();

-- Create function to clean up expired rate limits and CSRF tokens
CREATE OR REPLACE FUNCTION cleanup_auth_security()
RETURNS void AS $$
BEGIN
  -- Clean up expired rate limits
  DELETE FROM auth_rate_limits
  WHERE blocked_until < now() - interval '1 hour';

  -- Clean up expired CSRF tokens
  DELETE FROM auth_csrf_tokens
  WHERE expires_at < now();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Enable RLS on new tables
ALTER TABLE auth_rate_limits ENABLE ROW LEVEL SECURITY;
ALTER TABLE auth_csrf_tokens ENABLE ROW LEVEL SECURITY;

-- Create policies for rate limits (only service role can manage)
CREATE POLICY "rate_limits_service_only" ON auth_rate_limits
  FOR ALL TO service_role;

-- Create policies for CSRF tokens
CREATE POLICY "csrf_tokens_user_access" ON auth_csrf_tokens
  FOR ALL TO authenticated
  USING (user_id = auth.uid() OR user_id IS NULL);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_email_verified ON users(email_verified);
CREATE INDEX IF NOT EXISTS idx_users_last_login_at ON users(last_login_at);