/*
  # Fix Users Table Column Issues

  1. Ensure all required columns exist in users table
  2. Fix schema cache issues
  3. Add missing columns explicitly
*/

-- Check if columns exist and add them if missing
DO $$
BEGIN
    -- Add email_verified column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'email_verified'
    ) THEN
        ALTER TABLE users ADD COLUMN email_verified boolean DEFAULT false;
        COMMENT ON COLUMN users.email_verified IS 'Whether the user email has been verified';
    END IF;

    -- Add oauth_provider column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'oauth_provider'
    ) THEN
        ALTER TABLE users ADD COLUMN oauth_provider text;
        COMMENT ON COLUMN users.oauth_provider IS 'OAuth provider used for authentication';
    END IF;

    -- Add oauth_id column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'oauth_id'
    ) THEN
        ALTER TABLE users ADD COLUMN oauth_id text;
        COMMENT ON COLUMN users.oauth_id IS 'OAuth provider user ID';
    END IF;

    -- Add last_login_at column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'last_login_at'
    ) THEN
        ALTER TABLE users ADD COLUMN last_login_at timestamptz;
        COMMENT ON COLUMN users.last_login_at IS 'Timestamp of last login';
    END IF;

    -- Add login_attempts column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'login_attempts'
    ) THEN
        ALTER TABLE users ADD COLUMN login_attempts integer DEFAULT 0;
        COMMENT ON COLUMN users.login_attempts IS 'Number of failed login attempts';
    END IF;

    -- Add locked_until column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'locked_until'
    ) THEN
        ALTER TABLE users ADD COLUMN locked_until timestamptz;
        COMMENT ON COLUMN users.locked_until IS 'Account lock expiration timestamp';
    END IF;

    -- Add updated_at column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' 
        AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE users ADD COLUMN updated_at timestamptz DEFAULT now();
        COMMENT ON COLUMN users.updated_at IS 'Last update timestamp';
    END IF;

    -- Ensure constraints exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'users_role_check'
    ) THEN
        ALTER TABLE users ADD CONSTRAINT users_role_check 
        CHECK (role IN ('admin', 'staff'));
    END IF;
END $$;

-- Update the function to handle missing columns gracefully
CREATE OR REPLACE FUNCTION handle_google_oauth_user()
RETURNS trigger AS $$
BEGIN
    -- Only process if this is a Google OAuth signup
    IF NEW.raw_user_meta_data->>'provider' = 'google' THEN
        -- Insert or update user profile with safe column handling
        INSERT INTO users (
            id, 
            email, 
            name, 
            role, 
            oauth_provider, 
            oauth_id, 
            email_verified, 
            updated_at
        ) VALUES (
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
            updated_at = now()
        WHERE users.id = NEW.id;

        -- Update last login timestamp if column exists
        BEGIN
            UPDATE users 
            SET last_login_at = now() 
            WHERE id = NEW.id;
        EXCEPTION 
            WHEN undefined_column THEN
                -- Skip if column doesn't exist yet
                NULL;
        END;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Ensure indexes exist for performance
CREATE INDEX IF NOT EXISTS idx_users_email_verified ON users(email_verified);
CREATE INDEX IF NOT EXISTS idx_users_oauth_provider ON users(oauth_provider);
CREATE INDEX IF NOT EXISTS idx_users_oauth_id ON users(oauth_id);
CREATE INDEX IF NOT EXISTS idx_users_last_login_at ON users(last_login_at);
CREATE INDEX IF NOT EXISTS idx_users_locked_until ON users(locked_until);
CREATE INDEX IF NOT EXISTS idx_users_updated_at ON users(updated_at);

-- Update RLS policies to be more robust
DROP POLICY IF EXISTS "users_insert_policy" ON users;
DROP POLICY IF EXISTS "users_select_policy" ON users;
DROP POLICY IF EXISTS "users_update_policy" ON users;
DROP POLICY IF EXISTS "admin_manage_users" ON users;

-- Create more specific policies
CREATE POLICY "users_can_insert_own_profile" ON users
  FOR INSERT TO authenticated
  WITH CHECK (
    auth.uid() = id
    OR EXISTS (
      SELECT 1 FROM users u 
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

CREATE POLICY "users_can_select_own_profile" ON users
  FOR SELECT TO authenticated
  USING (
    auth.uid() = id
    OR EXISTS (
      SELECT 1 FROM users u 
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
    OR (
      EXISTS (
        SELECT 1 FROM users u 
        WHERE u.id = auth.uid() AND u.role = 'staff'
      ) 
      AND auth.uid() = id
    )
  );

CREATE POLICY "users_can_update_own_profile" ON users
  FOR UPDATE TO authenticated
  USING (
    auth.uid() = id
    OR EXISTS (
      SELECT 1 FROM users u 
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  )
  WITH CHECK (
    auth.uid() = id
    OR EXISTS (
      SELECT 1 FROM users u 
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

CREATE POLICY "admin_manage_all_users" ON users
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u 
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- Create a view for easier column access
CREATE OR REPLACE VIEW users_view AS
SELECT 
    id,
    email,
    name,
    role,
    created_at,
    last_login_at,
    login_attempts,
    locked_until,
    email_verified,
    oauth_provider,
    oauth_id,
    updated_at
FROM users;

-- Grant access to the view
GRANT SELECT ON users_view TO authenticated;