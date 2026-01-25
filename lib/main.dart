import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  // グローバルなエラーハンドリングを設定
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // 未処理のエラーをキャッチ
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // .envファイルの読み込み（オプショナル）
      try {
        await dotenv.load(fileName: 'assets/.env');
      } catch (e) {
        // .envファイルが存在しない場合は無視（デバッグモードでは問題なし）
        debugPrint('Warning: Could not load .env file: $e');
      }

      // Supabaseの初期化
      final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
      if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        );
      } else {
        debugPrint(
          'Warning: SUPABASE_URL or SUPABASE_ANON_KEY is missing in assets/.env',
        );
      }

      timeago.setLocaleMessages('ja', timeago.JaMessages());
      timeago.setDefaultLocale('ja');

      runApp(const ProviderScope(child: App()));
    },
    (error, stack) {
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stack');
    },
  );
}
