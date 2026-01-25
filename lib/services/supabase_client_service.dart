import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:off_training_note/services/app_error_service.dart';

class SupabaseClientProvider {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<T> guard<T>(
    Future<T> Function(SupabaseClient client) action, {
    String? userMessage,
  }) async {
    try {
      return await action(client);
    } catch (error, stackTrace) {
      AppErrorService.instance.handle(
        error,
        stackTrace,
        userMessage: userMessage,
      );
      rethrow;
    }
  }
}
