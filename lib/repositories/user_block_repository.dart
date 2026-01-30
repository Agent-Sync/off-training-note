import 'package:off_training_note/services/supabase_client_service.dart';

class UserBlockRepository {
  const UserBlockRepository();

  Future<void> blockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    await SupabaseClientProvider.guard(
      (client) => client.from('user_blocks').upsert(
            {
              'blocker_id': blockerId,
              'blocked_id': blockedId,
            },
            onConflict: 'blocker_id,blocked_id',
          ),
      userMessage: 'ブロックに失敗しました。',
    );
  }

  Future<void> unblockUser({
    required String blockerId,
    required String blockedId,
  }) async {
    await SupabaseClientProvider.guard(
      (client) => client
          .from('user_blocks')
          .delete()
          .eq('blocker_id', blockerId)
          .eq('blocked_id', blockedId),
      userMessage: 'ブロック解除に失敗しました。',
    );
  }
}
