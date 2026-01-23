class Profile {
  const Profile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
  });

  final String id;
  final String? displayName;
  final String? avatarUrl;

  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      id: data['id'] as String,
      displayName: data['display_name'] as String?,
      avatarUrl: data['avatar_url'] as String?,
    );
  }
}
