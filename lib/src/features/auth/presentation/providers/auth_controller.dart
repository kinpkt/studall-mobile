// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/models/user_model.dart';
// import '../../data/repositories/auth_repository.dart';
// import 'auth_state_provider.dart';

// /// State class for authentication operations
// class AuthState {
//   final bool isLoading;
//   final String? error;
//   final UserModel? user;

//   const AuthState({this.isLoading = false, this.error, this.user});

//   AuthState copyWith({bool? isLoading, String? error, UserModel? user}) {
//     return AuthState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//       user: user ?? this.user,
//     );
//   }
// }

// /// Controller for authentication actions
// class AuthController extends StateNotifier<AuthState> {
//   final AuthRepository _authRepository;

//   AuthController(this._authRepository) : super(const AuthState());

//   /// Sign in with email and password
//   Future<void> signInWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final user = await _authRepository.signInWithEmail(
//         email: email,
//         password: password,
//       );
//       state = state.copyWith(isLoading: false, user: user);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   /// Sign up with email and password
//   Future<void> signUpWithEmail({
//     required String email,
//     required String password,
//     String? displayName,
//   }) async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final user = await _authRepository.signUpWithEmail(
//         email: email,
//         password: password,
//         displayName: displayName,
//       );
//       state = state.copyWith(isLoading: false, user: user);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   /// Sign in with Google
//   Future<void> signInWithGoogle() async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final user = await _authRepository.signInWithGoogle();
//       state = state.copyWith(isLoading: false, user: user);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   /// Sign out
//   Future<void> signOut() async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       await _authRepository.signOut();
//       state = state.copyWith(isLoading: false, user: null);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   /// Clear error
//   void clearError() {
//     state = state.copyWith(error: null);
//   }
// }

// /// Provider for AuthController
// final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
//   (ref) {
//     final authRepository = ref.watch(authRepositoryProvider);
//     return AuthController(authRepository);
//   },
// );
