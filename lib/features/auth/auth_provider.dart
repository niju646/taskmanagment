import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _auth.authStateChanges().listen((user) {
      state = state.copyWith(user: user);
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
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
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

// import 'dart:developer';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
//   (ref) => AuthNotifier(),
// );

// class AuthNotifier extends StateNotifier<AuthState> {
//   AuthNotifier() : super(const AuthState()) {
//     _checkInitialUser();
//   }

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   /// Check if already logged in
//   void _checkInitialUser() {
//     final user = _auth.currentUser;
//     if (user != null) {
//       state = state.copyWith(user: user);
//     }
//   }

//   /// LOGIN
//   Future<void> login({required String email, required String password}) async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       state = state.copyWith(isLoading: false, user: credential.user);
//     } on FirebaseAuthException catch (e) {
//       log("Login error: ${e.code}");
//       state = state.copyWith(isLoading: false, error: e.message);
//     } catch (e) {
//       log("Login error: $e");
//       state = state.copyWith(isLoading: false, error: "Something went wrong");
//     }
//   }

//   /// REGISTER
//   Future<void> register({
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       state = state.copyWith(isLoading: false, user: credential.user);
//     } on FirebaseAuthException catch (e) {
//       state = state.copyWith(isLoading: false, error: e.message);
//     }
//   }

//   /// LOGOUT
//   Future<void> logout() async {
//     await _auth.signOut();
//     state = const AuthState();
//   }
// }

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, User? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}
