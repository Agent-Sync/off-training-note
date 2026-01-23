import 'package:flutter/material.dart';
import 'package:off_training_note/navigation/route_observer.dart';
import 'package:off_training_note/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'オフトレノート',
      theme: AppTheme.theme,
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const AuthGate());
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const AuthGate());
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<void> _signInWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.kafu.offtrainingnote://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e, stack) {
      debugPrint('signIn error: $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStream = Supabase.instance.client.auth.onAuthStateChange
        .map((data) => data.session);
    return StreamBuilder<Session?>(
      stream: authStream,
      initialData: Supabase.instance.client.auth.currentSession,
      builder: (context, snapshot) {
        final session = snapshot.data;
        if (session == null) {
          return LoginScreen(onSignIn: _signInWithGoogle);
        }
        return const HomeScreen();
      },
    );
  }
}
