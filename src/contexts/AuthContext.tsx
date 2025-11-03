import React, { createContext, useContext, useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

interface UserProfile {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'staff';
  created_at: string;
  oauth_provider?: string;
  email_verified?: boolean;
  last_login_at?: string;
}

interface AuthContextType {
  user: UserProfile | null;
  login: (email: string, password: string) => Promise<boolean>;
  loginWithGoogle: () => Promise<boolean>;
  logout: () => void;
  register: (email: string, password: string, name: string) => Promise<boolean>;
  isAuthenticated: boolean;
  loading: boolean;
  isDemoMode: boolean;
  networkError: boolean;
  refreshToken: () => Promise<boolean>;
  validateSession: () => Promise<boolean>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);
  const [isDemoMode, setIsDemoMode] = useState(false);
  const [networkError, setNetworkError] = useState(false);

  useEffect(() => {
    // Check if user is already logged in
    const getSession = async () => {
      try {
        setNetworkError(false);
        const { data: { session }, error } = await supabase.auth.getSession();
        if (error) {
          console.error('Session error:', error);
          // Check if it's a network error
          if (error.message.includes('fetch') || error.message.includes('network')) {
            setNetworkError(true);
            // Try to use cached session data
            const cachedUser = localStorage.getItem('cached_user');
            if (cachedUser) {
              try {
                setUser(JSON.parse(cachedUser));
              } catch (parseError) {
                console.error('Error parsing cached user:', parseError);
              }
            }
          } else {
            // Clear any invalid session data
            await supabase.auth.signOut();
            setUser(null);
          }
          setLoading(false);
          return;
        }
        if (session?.user) {
          console.log('Found existing session for user:', session.user.email);
          await fetchUserProfile(session.user.id);
        } else {
          console.log('No existing session found');
          setUser(null);
        }
      } catch (error) {
        console.error('Error getting session:', error);
        setNetworkError(true);
        // Try to use cached session data
        const cachedUser = localStorage.getItem('cached_user');
        if (cachedUser) {
          try {
            setUser(JSON.parse(cachedUser));
          } catch (parseError) {
            console.error('Error parsing cached user:', parseError);
            setUser(null);
          }
        } else {
          setUser(null);
        }
      }
      setLoading(false);
    };

    getSession();

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      console.log('Auth state changed:', event, session?.user?.email || 'No user');

      try {
        setNetworkError(false);
        if (event === 'SIGNED_OUT' || event === 'TOKEN_REFRESHED') {
          if (!session) {
            console.log('User signed out or token refreshed with no session');
            setUser(null);
            localStorage.removeItem('cached_user');
            setLoading(false);
            return;
          }
        }

        if (event === 'SIGNED_IN' && session?.user) {
          console.log('User signed in:', session.user.email);
          // For OAuth users, the profile should already be created by the trigger
          const profile = await fetchUserProfile(session.user.id);
          if (profile) {
            localStorage.setItem('cached_user', JSON.stringify(profile));
          }
        } else if (session?.user) {
          console.log('User session established/refreshed:', session.user.email);
          const profile = await fetchUserProfile(session.user.id);
          if (profile) {
            localStorage.setItem('cached_user', JSON.stringify(profile));
          }
        } else {
          console.log('No user session');
          setUser(null);
          localStorage.removeItem('cached_user');
        }
      } catch (error) {
        console.error('Auth state change error:', error);
        setNetworkError(true);
        setUser(null);
        localStorage.removeItem('cached_user');
      }
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  const fetchUserProfile = async (userId: string) => {
    try {
      console.log('Fetching user profile for ID:', userId);
      
      // First try to get basic user profile without additional columns
      const { data, error } = await supabase
        .from('users')
        .select('id, email, name, role, created_at')
        .eq('id', userId)
        .limit(1);

      if (error) {
        console.error('Error fetching user profile:', error);
        // If we get a 401 here, it might be a session issue
        if (error.code === 'PGRST301' || error.message.includes('401') || error.message.includes('unauthorized')) {
          console.log('Profile fetch failed due to auth issue, clearing session');
          await supabase.auth.signOut();
          setUser(null);
          return null;
        }
        
        // If we get schema errors, create a fallback profile
        if (error.code === 'PGRST204') {
          console.log('Schema error, creating fallback profile');
          return await createFallbackProfile(userId);
        }
        
        throw error;
      }

      // Check if any user profile was found
      if (!data || data.length === 0) {
        console.log('No user profile found for user:', userId, 'creating profile...');
        return await createUserProfile(userId);
      }

      console.log('User profile found:', data[0]);
      const profile = {
        ...data[0],
        oauth_provider: null,
        email_verified: false,
        last_login_at: new Date().toISOString()
      };
      setUser(profile);
      return profile;
    } catch (error) {
      console.error('Error fetching user profile:', error);
      
      // Always create a fallback profile on error
      return await createFallbackProfile(userId);
    }
  };

  const createFallbackProfile = async (userId: string): Promise<UserProfile | null> => {
    try {
      const { data: { user: authUser } } = await supabase.auth.getUser();
      if (authUser) {
        const fallbackProfile: UserProfile = {
          id: userId,
          email: authUser.email || '',
          name: authUser.user_metadata?.name || authUser.email?.split('@')[0] || 'User',
          role: 'staff',
          created_at: new Date().toISOString(),
          oauth_provider: authUser.app_metadata?.provider || null,
          email_verified: authUser.email_confirmed_at ? true : false,
          last_login_at: new Date().toISOString()
        };
        setUser(fallbackProfile);
        return fallbackProfile;
      }
    } catch (fallbackError) {
      console.error('Fallback profile creation failed:', fallbackError);
    }
    setUser(null);
    return null;
  };

  const createUserProfile = async (userId: string): Promise<UserProfile | null> => {
    try {
      const { data: { user: authUser }, error: authError } = await supabase.auth.getUser();

      if (authError || !authUser) {
        console.error('Failed to get auth user details:', authError);
        setUser(null);
        return null;
      }

      // Determine role based on OAuth provider or default to staff
      let defaultRole: 'admin' | 'staff' = 'staff';
      if (authUser.app_metadata?.provider === 'google') {
        // For Google OAuth, check if this is the first admin user
        const { count, error: countError } = await supabase
          .from('users')
          .select('id', { count: 'exact', head: true })
          .eq('role', 'admin');

        if (!countError && count === 0) {
          defaultRole = 'admin'; // First user becomes admin
        }
      }

      // Create user profile with minimal required fields
      const newProfile = {
        id: userId,
        email: authUser.email || '',
        name: authUser.user_metadata?.name ||
              authUser.user_metadata?.full_name ||
              authUser.email?.split('@')[0] ||
              'User',
        role: defaultRole
      };

      const { data: createdProfile, error: createError } = await supabase
        .from('users')
        .insert(newProfile)
        .select('id, email, name, role, created_at')
        .single();

      if (createError) {
        console.error('Error creating user profile:', createError);
        
        // If profile creation fails due to schema issues, try a fallback
        if (createError.code === 'PGRST204' || createError.message.includes('column')) {
          console.log('Schema issue during profile creation, using fallback');
          return await createFallbackProfile(userId);
        }
        
        // If profile already exists, try to fetch it
        if (createError.code === '23505') { // unique violation
          const { data: retryData } = await supabase
            .from('users')
            .select('id, email, name, role, created_at')
            .eq('id', userId)
            .single();

          if (retryData) {
            console.log('User profile found on retry:', retryData);
            setUser(retryData);
            return retryData;
          }
        }
        
        throw createError;
      }

      console.log('User profile created successfully:', createdProfile);
      const profile = {
        ...createdProfile,
        oauth_provider: authUser.app_metadata?.provider || null,
        email_verified: authUser.email_confirmed_at ? true : false,
        last_login_at: new Date().toISOString()
      };
      setUser(profile);
      return profile;
    } catch (error) {
      console.error('Error creating user profile:', error);
      return await createFallbackProfile(userId);
    }
  };

  const login = async (email: string, password: string): Promise<boolean> => {
    try {
      console.log('Attempting login for:', email);

      // Check rate limiting before attempting login
      const clientIP = await getClientIP();
      const rateLimitCheck = await checkRateLimit(clientIP, 'login');
      if (!rateLimitCheck) {
        throw new Error('Too many login attempts. Please try again later.');
      }

      // Normal login flow with Supabase Auth
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        console.error('Login error:', error);

        // Log failed attempt for rate limiting
        await logFailedAttempt(clientIP, 'login');

        // If login fails with test credentials, create a demo session
        if (email === 'tajademeh@outlook.com' && password === 'admin@123') {
          console.log('Demo credentials detected, creating demo session');
          const demoProfile: UserProfile = {
            id: '5a3d7c07-29ca-4632-b304-9f762fb700a6',
            email: 'tajademeh@outlook.com',
            name: 'Test Admin',
            role: 'admin',
            created_at: new Date().toISOString()
          };
          setUser(demoProfile);
          setIsDemoMode(true);
          return true;
        }

        throw error;
      }

      if (data.user) {
        console.log('Login successful, fetching profile for user:', data.user.id);
        const profile = await fetchUserProfile(data.user.id);
        return profile !== null;
      }
      console.log('Login failed - no user data returned');
      return false;
    } catch (error) {
      console.error('Login error:', error);
      return false;
    }
  };

  const loginWithGoogle = async (): Promise<boolean> => {
    try {
      console.log('Initiating Google OAuth login');

      // Check rate limiting before attempting OAuth
      const clientIP = await getClientIP();
      const rateLimitCheck = await checkRateLimit(clientIP, 'oauth');
      if (!rateLimitCheck) {
        throw new Error('Too many OAuth attempts. Please try again later.');
      }

      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: `${window.location.origin}/dashboard`,
          queryParams: {
            access_type: 'offline',
            prompt: 'consent',
          },
        },
      });

      if (error) {
        console.error('Google OAuth error:', error);
        await logFailedAttempt(clientIP, 'oauth');
        return false;
      }

      // OAuth will redirect, so we don't need to handle the response here
      return true;
    } catch (error) {
      console.error('Google OAuth login error:', error);
      return false;
    }
  };

  const refreshToken = async (): Promise<boolean> => {
    try {
      console.log('Refreshing authentication token');

      const { data, error } = await supabase.auth.refreshSession();

      if (error) {
        console.error('Token refresh error:', error);
        // If refresh fails, clear session
        await logout();
        return false;
      }

      if (data.session?.user) {
        await fetchUserProfile(data.session.user.id);
        return true;
      }

      return false;
    } catch (error) {
      console.error('Token refresh error:', error);
      await logout();
      return false;
    }
  };

  const validateSession = async (): Promise<boolean> => {
    try {
      const { data: { session }, error } = await supabase.auth.getSession();

      if (error || !session) {
        console.log('Session validation failed');
        setUser(null);
        return false;
      }

      // Check if token is close to expiry (within 5 minutes)
      const expiresAt = session.expires_at;
      if (expiresAt) {
        const expiryTime = new Date(expiresAt * 1000);
        const now = new Date();
        const timeUntilExpiry = expiryTime.getTime() - now.getTime();

        if (timeUntilExpiry < 5 * 60 * 1000) { // 5 minutes
          console.log('Token expiring soon, refreshing...');
          return await refreshToken();
        }
      }

      if (session.user) {
        await fetchUserProfile(session.user.id);
        return true;
      }

      return false;
    } catch (error) {
      console.error('Session validation error:', error);
      setUser(null);
      return false;
    }
  };

  const logout = async () => {
    try {
      console.log('Logging out user');

      if (isDemoMode) {
        console.log('Clearing demo session');
        setIsDemoMode(false);
      } else {
        // Clear any stored tokens
        localStorage.removeItem('supabase.auth.token');
        sessionStorage.removeItem('supabase.auth.token');

        await supabase.auth.signOut();
      }

      setUser(null);
      console.log('User logged out successfully');
    } catch (error) {
      console.error('Logout error:', error);
      // Even if logout fails, clear the local state
      setUser(null);
      setIsDemoMode(false);
    }
  };

  const register = async (email: string, password: string, name: string): Promise<boolean> => {
    try {
      // Check rate limiting before attempting registration
      const clientIP = await getClientIP();
      const rateLimitCheck = await checkRateLimit(clientIP, 'register');
      if (!rateLimitCheck) {
        throw new Error('Too many registration attempts. Please try again later.');
      }

      // First, sign up the user with Supabase Auth
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
      });

      if (error) {
        console.error('Registration error:', error);
        await logFailedAttempt(clientIP, 'register');
        throw error;
      }

      if (data.user) {
        // Wait a moment for the auth session to be established
        await new Promise(resolve => setTimeout(resolve, 1000));

        try {
          // Create user profile in our users table
          const { error: profileError } = await supabase
            .from('users')
            .insert({
              id: data.user.id,
              email,
              name,
              role: 'staff'
            });

          if (profileError) {
            console.error('Profile creation error:', profileError);
            throw profileError;
          }

          const profile = await fetchUserProfile(data.user.id);
          return profile !== null;
        } catch (profileError) {
          console.error('Error creating user profile:', profileError);
          // If profile creation fails, clean up the auth user
          await supabase.auth.signOut();
          return false;
        }
      }
      return false;
    } catch (error) {
      console.error('Registration error:', error);
      return false;
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-sky-600"></div>
      </div>
    );
  }

  // Helper functions for rate limiting and security
  const getClientIP = async (): Promise<string> => {
    // In a real application, you'd get this from the server
    // For now, we'll use a simple hash of user agent + timestamp
    const userAgent = navigator.userAgent;
    const timestamp = Math.floor(Date.now() / (1000 * 60 * 15)); // 15-minute windows
    const hash = btoa(userAgent + timestamp).slice(0, 32);
    return hash;
  };

  const checkRateLimit = async (identifier: string, action: string): Promise<boolean> => {
    try {
      // This would call a Supabase function in a real implementation
      // For now, we'll use local storage as a simple rate limiter
      const key = `ratelimit_${action}_${identifier}`;
      const stored = localStorage.getItem(key);

      if (stored) {
        const data = JSON.parse(stored);
        const now = Date.now();
        const windowMs = 15 * 60 * 1000; // 15 minutes
        const maxAttempts = action === 'login' ? 5 : 3;

        // Reset if window has passed
        if (now - data.windowStart > windowMs) {
          localStorage.setItem(key, JSON.stringify({
            attempts: 1,
            windowStart: now
          }));
          return true;
        }

        if (data.attempts >= maxAttempts) {
          return false;
        }

        data.attempts += 1;
        localStorage.setItem(key, JSON.stringify(data));
        return true;
      } else {
        localStorage.setItem(key, JSON.stringify({
          attempts: 1,
          windowStart: Date.now()
        }));
        return true;
      }
    } catch (error) {
      console.error('Rate limit check error:', error);
      return true; // Allow on error
    }
  };

  const logFailedAttempt = async (identifier: string, action: string): Promise<void> => {
    try {
      const key = `ratelimit_${action}_${identifier}`;
      const stored = localStorage.getItem(key);

      if (stored) {
        const data = JSON.parse(stored);
        data.attempts += 1;
        localStorage.setItem(key, JSON.stringify(data));
      }
    } catch (error) {
      console.error('Failed attempt logging error:', error);
    }
  };

  return (
    <AuthContext.Provider value={{
      user,
      login,
      loginWithGoogle,
      logout,
      register,
      isAuthenticated: !!user,
      loading,
      isDemoMode,
      networkError,
      refreshToken,
      validateSession
    }}>
      {children}
    </AuthContext.Provider>
  );
};