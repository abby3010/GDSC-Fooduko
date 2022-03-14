class FoodukoUser {
  FoodukoUser({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.displayName,
    required this.phoneNumber,
  });

  final String uid;
  final String? email;
  final String? photoUrl;
  final String? displayName;
  final String? phoneNumber;
}
