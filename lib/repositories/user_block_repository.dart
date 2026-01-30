import 'package:off_training_note/services/supabase_client_service.dart';

class UserBlockRepository {
  const UserBlockRepository();

  Future<Set<String>> fetchBlockedUserIds({
    required String blockerId,
  }) async {
    final rows = await SupabaseClientProvider.guard(
      (client) => client
          .from('user_blocks')
          .select('blocked_id')
          .eq('blocker_id', blockerId),
      userMessage: 'ブロック一覧の取得に失敗しました。',
    );
    final list = rows as List<dynamic>;
    return list
        .map((row) => (row as Map<String, dynamic>)['blocked_id'] as String)
        .toSet();
  }

  Future<bool> isBlocked({
    required String blockerId,
    required String blockedId,
  }) async {
    final rows = await SupabaseClientProvider.guard(
      (client) => client
          .from('user_blocks')
          .select('blocked_id')
          .eq('blocker_id', blockerId)
          .eq('blocked_id', blockedId)
          .limit(1),
      userMessage: 'ブロック状態の取得に失敗しました。',
    );
    return (rows as List<dynamic>).isNotEmpty;
  }

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
