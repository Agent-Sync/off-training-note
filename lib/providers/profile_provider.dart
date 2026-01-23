import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authSessionProvider = StreamProvider<Session?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange
      .map((data) => data.session);
});

final profileProvider = FutureProvider<Profile?>((ref) async {
  final session = ref.watch(authSessionProvider).value ??
      Supabase.instance.client.auth.currentSession;
  final user = session?.user;
  if (user == null) {
    return null;
  }

  final data = await Supabase.instance.client
      .from('profiles')
      .select('id, display_name, avatar_url')
      .eq('id', user.id)
      .maybeSingle();

  if (data == null) {
    return null;
  }

  return Profile.fromMap(data);
});
