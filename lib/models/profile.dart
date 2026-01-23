class Profile {
  const Profile({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.onboarded,
  });

  final String userId;
  final String? displayName;
  final String? avatarUrl;
  final bool onboarded;

  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      userId: data['id'] as String,
      displayName: data['display_name'] as String?,
      avatarUrl: data['avatar_url'] as String?,
      onboarded: data['onboarded'] as bool? ?? false,
    );
  }
}
