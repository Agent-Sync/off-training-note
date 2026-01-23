import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/repositories/profile_repository.dart';
import 'package:off_training_note/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authSessionProvider = StreamProvider<Session?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange
      .map((data) => data.session);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return const ProfileRepository();
});

final profileProvider = FutureProvider<Profile?>((ref) async {
  final session = ref.watch(authSessionProvider).value ??
      Supabase.instance.client.auth.currentSession;
  final user = session?.user;
  if (user == null) {
    return null;
  }

  final repo = ref.read(profileRepositoryProvider);
  return repo.fetchProfile(userId: user.id);
});
