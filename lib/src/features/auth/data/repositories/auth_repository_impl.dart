// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../models/user_model.dart';
// import 'auth_repository.dart';

// /// Firebase Implementation of AuthRepository
// class AuthRepositoryImpl implements AuthRepository {
//   final FirebaseAuth _firebaseAuth;
//   final GoogleSignIn _googleSignIn;

//   AuthRepositoryImpl({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
//     : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//       _googleSignIn = googleSignIn ?? GoogleSignIn();

//   @override
//   Future<UserModel?> getCurrentUser() async {
//     final user = _firebaseAuth.currentUser;
//     if (user == null) return null;
//     return UserModel.fromFirebase(user);
//   }

//   @override
//   Future<UserModel> signInWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final credential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (credential.user == null) {
//         throw Exception('Sign in failed');
//       }

//       return UserModel.fromFirebase(credential.user!);
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     }
//   }

//   @override
//   Future<UserModel> signUpWithEmail({
//     required String email,
//     required String password,
//     String? displayName,
//   }) async {
//     try {
//       final credential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (credential.user == null) {
//         throw Exception('Sign up failed');
//       }

//       // Update display name if provided
//       if (displayName != null) {
//         await credential.user!.updateDisplayName(displayName);
//         await credential.user!.reload();
//       }

//       return UserModel.fromFirebase(_firebaseAuth.currentUser!);
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     }
//   }

//   @override
//   Future<UserModel> signInWithGoogle() async {
//     try {
//       // Trigger the Google Sign In flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         throw Exception('Google sign in was cancelled');
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credential
//       final userCredential = await _firebaseAuth.signInWithCredential(
//         credential,
//       );

//       if (userCredential.user == null) {
//         throw Exception('Google sign in failed');
//       }

//       return UserModel.fromFirebase(userCredential.user!);
//     } on FirebaseAuthException catch (e) {
//       throw _handleAuthException(e);
//     } catch (e) {
//       throw Exception('Google sign in error: $e');
//     }
//   }

//   @override
//   Future<void> signOut() async {
//     await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
//   }

//   @override
//   Stream<UserModel?> authStateChanges() {
//     return _firebaseAuth.authStateChanges().map((user) {
//       if (user == null) return null;
//       return UserModel.fromFirebase(user);
//     });
//   }

//   /// Handle Firebase Auth exceptions
//   String _handleAuthException(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'user-not-found':
//         return 'No user found with this email';
//       case 'wrong-password':
//         return 'Wrong password';
//       case 'email-already-in-use':
//         return 'Email already in use';
//       case 'invalid-email':
//         return 'Invalid email address';
//       case 'weak-password':
//         return 'Password is too weak';
//       case 'user-disabled':
//         return 'This user has been disabled';
//       case 'too-many-requests':
//         return 'Too many attempts. Please try again later';
//       default:
//         return 'Authentication error: ${e.message}';
//     }
//   }
// }
