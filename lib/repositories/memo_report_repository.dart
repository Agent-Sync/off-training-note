import 'package:off_training_note/services/supabase_client_service.dart';

class MemoReportRepository {
  const MemoReportRepository();

  Future<void> reportMemo({
    required String memoId,
    required String userId,
  }) async {
    await SupabaseClientProvider.guard(
      (client) => client
          .from('memo_reports')
          .upsert(
            {
              'memo_id': memoId,
              'reported_by': userId,
            },
            onConflict: 'memo_id,reported_by',
          ),
      userMessage: '報告に失敗しました。',
    );
  }
}
