class StoredCredentials {
  final String? username;
  final String? password;
  bool get hasCredentials => username != null && password != null;

  StoredCredentials({required this.username, required this.password});
}
