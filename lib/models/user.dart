class AppUser {
  final String id;
  final String email;
  String? displayName;

  AppUser({required this.id, required this.email, this.displayName});

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(id: m['id'], email: m['email'], displayName: m['displayName']);

  Map<String, dynamic> toMap() => {'id': id, 'email': email, 'displayName': displayName};
}