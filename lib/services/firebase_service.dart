import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    print("---------------1");
    try {
      UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("qq---------------");
      print(credential.user?.email);
      return credential.user;
    } catch (e) {
      print("eee----------- : $e");
      // if (e.code == 'user-not-found') {
      //   print('No user found for that email.');
      // } else if (e.code == 'wrong-password') {
      //   print('Wrong password provided for that user.');
      // }
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
