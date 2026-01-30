class Profile {
  const Profile({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.onboarded,
    this.isBlockedByMe = false,
  });

  final String userId;
  final String? displayName;
  final String? avatarUrl;
  final bool onboarded;
  final bool isBlockedByMe;

  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      userId: data['id'] as String,
      displayName: data['display_name'] as String?,
      avatarUrl: data['avatar_url'] as String?,
      onboarded: data['onboarded'] as bool? ?? false,
      isBlockedByMe: data['is_blocked_by_me'] as bool? ?? false,
    );
  }
}
