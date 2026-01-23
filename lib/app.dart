import 'package:flutter/material.dart';
import 'package:off_training_note/navigation/route_observer.dart';
import 'package:off_training_note/providers/profile_provider.dart';
import 'package:off_training_note/screens/onboarding_screen.dart';
import 'package:off_training_note/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class AuthGate extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(authSessionProvider);
    return sessionAsync.when(
      data: (session) {
        if (session == null) {
          return LoginScreen(onSignIn: _signInWithGoogle);
        }
        final profileAsync = ref.watch(profileProvider);
        return profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            if (!profile.onboarded) {
              return const OnboardingScreen();
            }
            return const HomeScreen();
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
          error: (error, stackTrace) => const Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.black),
      ),
      error: (error, stackTrace) => LoginScreen(onSignIn: _signInWithGoogle),
    );
  }
}
