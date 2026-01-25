import 'package:off_training_note/services/supabase_client_service.dart';
import 'package:off_training_note/models/profile.dart';

class ProfileRepository {
  const ProfileRepository();

  Future<Profile?> fetchProfile({required String userId}) async {
    final data = await SupabaseClientProvider.guard(
      (client) => client
          .from('profiles')
          .select('id, display_name, avatar_url, onboarded')
          .eq('id', userId)
          .maybeSingle(),
    );

    if (data == null) {
      return null;
    }

    return Profile.fromMap(data);
  }

  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
    bool? onboarded,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (displayName != null) {
      updates['display_name'] = displayName;
    }
    if (avatarUrl != null) {
      updates['avatar_url'] = avatarUrl;
    }
    if (onboarded != null) {
      updates['onboarded'] = onboarded;
    }

    await SupabaseClientProvider.guard(
      (client) => client.from('profiles').update(updates).eq('id', userId),
    );
  }
}
