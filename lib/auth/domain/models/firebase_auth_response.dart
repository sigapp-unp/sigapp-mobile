/// Response from Firebase authentication from API Gateway
class FirebaseAuthResponse {
  final String firebaseCustomToken;
  final int expiresIn;
  final Map<String, dynamic>? claims;

  const FirebaseAuthResponse({
    required this.firebaseCustomToken,
    required this.expiresIn,
    this.claims,
  });

  factory FirebaseAuthResponse.fromJson(Map<String, dynamic> json) {
    return FirebaseAuthResponse(
      firebaseCustomToken: json['firebaseCustomToken'] as String,
      expiresIn: json['expiresIn'] as int? ?? 3600,
      claims: json['claims'] as Map<String, dynamic>?,
    );
  }

  String? get studentCode => claims?['student_code'] as String?;

  String? get role => claims?['role'] as String?;

  DateTime? get validatedAt {
    final timestamp = claims?['validated_at'] as int?;
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        : null;
  }

  DateTime get expiresAt => DateTime.now().add(Duration(seconds: expiresIn));
}
