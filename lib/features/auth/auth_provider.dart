import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/core/storage/storage_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _listenToAuthChanges();
  }
  final _storage = ThemeStorageService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((user) {
      state = state.copyWith(
        user: user,
        isInitialized: true,
        isLoading: false,
        error: null,
        clearUser: user == null,
      );
      log("Auth state changed → user: ${user?.uid ?? 'null'}");
    });
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _storage.saveLoginSession(true);
      log("Login successful");
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? "Authentication failed",
      );
      log("Login failed: ${e.code} - ${e.message}");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("Registration successful");
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? "Registration failed",
      );
      log("Register failed: ${e.code} - ${e.message}");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _auth.signOut();

      log("Logout successful, cache cleared");
    } catch (e) {
      log("Logout error: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        state = state.copyWith(user: _auth.currentUser);
      }
    } catch (e) {
      log("Refresh user error: $e");
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;
  final bool isInitialized;

  const AuthState({
    this.isLoading = false,
    this.isInitialized = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    bool? isInitialized,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      user: clearUser ? null : (user ?? this.user),
      error: error,
    );
  }
}
