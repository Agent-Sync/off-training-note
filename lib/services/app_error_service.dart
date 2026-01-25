import 'package:flutter/material.dart';
import 'package:off_training_note/navigation/app_navigator.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/common/app_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppErrorService {
  AppErrorService._();

  static final AppErrorService instance = AppErrorService._();

  bool _isShowing = false;

  void handle(
    Object error,
    StackTrace stackTrace, {
    String? userMessage,
  }) {
    debugPrint('Supabase error: $error');
    debugPrint('$stackTrace');

    final context = appNavigatorKey.currentContext;
    if (context == null || _isShowing) return;

    _isShowing = true;
    final message = userMessage ?? _messageFor(error);

    showAppDialog<void>(
      context: context,
      barrierLabel: 'app_error_dialog',
      builder: (dialogContext) => AppDialog(
        title: 'エラーが発生しました',
        message: message,
        actions: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: AppTheme.textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      _isShowing = false;
    });
  }

  String _messageFor(Object error) {
    if (error is PostgrestException) {
      final msg = error.message.trim();
      return msg.isEmpty ? '通信に失敗しました。' : msg;
    }
    if (error is AuthException) {
      final msg = error.message.trim();
      return msg.isEmpty ? '認証エラーが発生しました。' : msg;
    }
    return '通信に失敗しました。時間をおいて再度お試しください。';
  }
}
