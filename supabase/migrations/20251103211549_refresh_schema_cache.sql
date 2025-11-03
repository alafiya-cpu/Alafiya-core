/*
  # Force Schema Cache Refresh and Column Validation

  1. Force refresh PostgREST schema cache
  2. Ensure all required columns exist
  3. Add missing indexes
  4. Refresh schema for PostgREST
*/

-- Force refresh the schema cache by sending a NOTIFY
SELECT pg_notify('pgrst', 'reload schema');

-- Refresh the schema cache manually
NOTIFY pgrst, 'reload schema';

-- Create or replace the users table with explicit column definitions
DO $$
BEGIN
    -- Ensure all columns exist with explicit data types
    ALTER TABLE users
        ALTER COLUMN id TYPE uuid USING id::uuid,
        ALTER COLUMN email TYPE text,
        ALTER COLUMN name TYPE text,
        ALTER COLUMN role TYPE text,
        ALTER COLUMN created_at TYPE timestamptz USING created_at::timestamptz;

    -- Add missing columns if they don't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'last_login_at'
    ) THEN
        ALTER TABLE users ADD COLUMN last_login_at timestamptz;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'email_verified'
    ) THEN
        ALTER TABLE users ADD COLUMN email_verified boolean DEFAULT false;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'oauth_provider'
    ) THEN
        ALTER TABLE users ADD COLUMN oauth_provider text;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'oauth_id'
    ) THEN
        ALTER TABLE users ADD COLUMN oauth_id text;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE users ADD COLUMN updated_at timestamptz DEFAULT now();
    END IF;
END $$;

-- Ensure constraints are properly defined
DO $$
BEGIN
    -- Add role constraint if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'users_role_check'
    ) THEN
        ALTER TABLE users ADD CONSTRAINT users_role_check 
        CHECK (role IN ('admin', 'staff'));
    END IF;
END $$;

-- Refresh all functions and triggers
DROP FUNCTION IF EXISTS handle_google_oauth_user();
DROP FUNCTION IF EXISTS update_last_login();

-- Recreate the Google OAuth handler function
CREATE OR REPLACE FUNCTION handle_google_oauth_user()
RETURNS trigger AS $$
BEGIN
    -- Only process if this is a Google OAuth signup
    IF NEW.raw_user_meta_data->>'provider' = 'google' THEN
        -- Insert or update user profile with minimal required fields
        INSERT INTO users (id, email, name, role, created_at)
        VALUES (
            NEW.id,
            NEW.email,
            COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
            'staff', -- Default role for OAuth users
            now()
        )
        ON CONFLICT (id) DO UPDATE SET
            email = EXCLUDED.email,
            name = EXCLUDED.name,
            updated_at = now()
        WHERE users.id = NEW.id;

        -- Try to update additional fields if columns exist
        BEGIN
            UPDATE users SET 
                last_login_at = now(),
                email_verified = true,
                oauth_provider = 'google',
                oauth_id = NEW.raw_user_meta_data->>'sub'
            WHERE id = NEW.id;
        EXCEPTION 
            WHEN undefined_column THEN
                -- Skip if columns don't exist yet
                NULL;
        END;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the login tracking function
CREATE OR REPLACE FUNCTION update_last_login()
RETURNS trigger AS $$
BEGIN
    -- Update last login if column exists
    BEGIN
        UPDATE users SET last_login_at = now() WHERE id = NEW.user_id;
    EXCEPTION 
        WHEN undefined_column THEN
            -- Skip if column doesn't exist
            NULL;
    END;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate triggers
DROP TRIGGER IF EXISTS on_auth_user_created_google ON auth.users;
DROP TRIGGER IF EXISTS on_auth_session_created ON auth.sessions;

CREATE TRIGGER on_auth_user_created_google
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_google_oauth_user();

CREATE TRIGGER on_auth_session_created
    AFTER INSERT ON auth.sessions
    FOR EACH ROW EXECUTE FUNCTION update_last_login();

-- Refresh RLS policies
DROP POLICY IF EXISTS "users_insert_policy" ON users;
DROP POLICY IF EXISTS "users_select_policy" ON users;
DROP POLICY IF EXISTS "users_update_policy" ON users;
DROP POLICY IF EXISTS "admin_manage_users" ON users;

-- Create simplified RLS policies
CREATE POLICY "users_basic_access" ON users
    FOR ALL TO authenticated
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

CREATE POLICY "admin_full_access" ON users
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Ensure indexes exist
CREATE INDEX IF NOT EXISTS idx_users_id ON users(id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_oauth_provider ON users(oauth_provider);

-- Drop and recreate the view for schema refresh
DROP VIEW IF EXISTS users_view;

CREATE VIEW users_view AS
SELECT 
    id,
    email,
    name,
    role,
    created_at,
    COALESCE(last_login_at, created_at::timestamptz) as last_login_at,
    0 as login_attempts,
    NULL as locked_until,
    COALESCE(email_verified, false) as email_verified,
    oauth_provider,
    oauth_id,
    COALESCE(updated_at, created_at::timestamptz) as updated_at
FROM users;

-- Grant access to view
GRANT SELECT ON users_view TO authenticated;

-- Force PostgREST to reload schema cache
SELECT pg_notify('pgrst', 'reload schema');

-- Log the completion
INSERT INTO public.schema_refresh_log (refreshed_at, tables_updated) 
VALUES (now(), ARRAY['users', 'users_view'])
ON CONFLICT DO NOTHING;