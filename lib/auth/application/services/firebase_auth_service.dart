abstract class FirebaseAuthService {
  /// Call the external backend and then sign in anonymously in Firebase
  Future<void> signInWithStudentCode(String studentCode, String password);

  /// Closes the session in Firebase
  Future<void> signOut();

  /// Returns the UID after signIn()
  Future<String> getCurrentUid();
}
