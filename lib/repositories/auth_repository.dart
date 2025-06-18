import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<User?> login(String email, String password) async {
    User? user = await _firebaseService.signIn(email, password);
    print("login ${user?.email}");
    return user;
  }

  Future<User?> register(String email, String password) {
    return _firebaseService.register(email, password);
  }

  Future<void> logout() {
    return _firebaseService.signOut();
  }

  User? getCurrentUser() {
    return _firebaseService.getCurrentUser();
  }
}
