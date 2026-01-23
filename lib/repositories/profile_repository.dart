import 'package:off_training_note/services/supabase_client_service.dart';
import 'package:off_training_note/models/profile.dart';

class ProfileRepository {
  const ProfileRepository();

  Future<Profile?> fetchProfile({required String userId}) async {
    final data = await SupabaseClientProvider.client
        .from('profiles')
        .select('id, display_name, avatar_url')
        .eq('id', userId)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return Profile.fromMap(data);
  }
}
