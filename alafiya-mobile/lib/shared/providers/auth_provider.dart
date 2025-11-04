// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:state_notifier/state_notifier.dart' as sn;

import '../models/user.dart';

/// Authentication Provider
/// Manages user authentication state using Riverpod StateNotifier
class AuthProvider extends sn.StateNotifier<AuthState> {
  final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;
  
  User? _currentUser;

  AuthProvider() : super(const AuthState()) {
    _initialize();
  }

  // Getters for accessing state properties
  bool get isLoading => state.isLoading;
  String? get error => state.error;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isNotAuthenticated => !isAuthenticated;

  /// Initialize authentication state
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Set up auth state listener
      _supabase.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          _loadCurrentUser(session.user.id).then((_) {
            state = state.copyWith(isAuthenticated: true, isLoading: false);
          });
        } else {
          _currentUser = null;
          state = state.copyWith(isAuthenticated: false, isLoading: false);
        }
      });
      
      // Check current session
      final session = _supabase.auth.currentSession;
      if (session != null) {
        await _loadCurrentUser(session.user.id);
        state = state.copyWith(isAuthenticated: true, isLoading: false);
      } else {
        state = state.copyWith(isAuthenticated: false, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Force re-initialize authentication (useful for testing)
  Future<void> reinitialize() async {
    await _initialize();
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadCurrentUser(response.user!.id);
        state = state.copyWith(isLoading: false, isAuthenticated: true);
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    } catch (e) {
      state = state.copyWith(error: _getErrorMessage(e), isLoading: false);
    }
  }

  /// Load current user from database
  Future<void> _loadCurrentUser(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      _currentUser = User.fromJson(response);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load user data: ${e.toString()}');
    }
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is supabase.AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid email or password';
        case 'Email not confirmed':
          return 'Please confirm your email address';
        case 'User already registered':
          return 'An account with this email already exists';
        default:
          return error.message;
      }
    }
    return error.toString();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth State
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}