abstract class AuthMethod {
  /// Login method that returns user data as a Map
  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  });

  /// Get user details using a token
  Future<Map<String, dynamic>?> getUserDetails(String token);
}
