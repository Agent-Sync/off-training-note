import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:off_training_note/navigation/app_navigator.dart';
import 'package:off_training_note/navigation/route_observer.dart';
import 'package:off_training_note/providers/profile_provider.dart';
import 'package:off_training_note/screens/onboarding_screen.dart';
import 'package:off_training_note/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider).value ??
        Supabase.instance.client.auth.currentSession;
    final sessionKey = session?.user.id ?? 'logged_out';
    return MaterialApp(
      title: 'オフトレノート',
      theme: AppTheme.theme,
      navigatorKey: appNavigatorKey,
      home: ProviderScope(
        key: ValueKey<String>(sessionKey),
        child: const AuthGate(),
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => ProviderScope(
            key: ValueKey<String>(sessionKey),
            child: const AuthGate(),
          ),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => ProviderScope(
            key: ValueKey<String>(sessionKey),
            child: const AuthGate(),
          ),
        );
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

  Future<void> _signInWithApple() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'com.kafu.offtrainingnote://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e, stack) {
      debugPrint('signIn error: $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  bool get _showAppleSignIn {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(authSessionProvider);
    
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: sessionAsync.when(
          data: (session) {
            if (session == null) {
              return LoginScreen(
                key: const ValueKey('login'),
                onSignInGoogle: _signInWithGoogle,
                onSignInApple: _showAppleSignIn ? _signInWithApple : null,
              );
            }
            final profileAsync = ref.watch(profileProvider);
            return profileAsync.when(
              data: (profile) {
                if (profile == null) {
                  return const Center(
                    key: ValueKey('loading_profile'),
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
                if (!profile.onboarded) {
                  return const OnboardingScreen(key: ValueKey('onboarding'));
                }
                return const HomeScreen(key: ValueKey('home'));
              },
              loading: () => const Center(
                key: ValueKey('loading_data'),
                child: CircularProgressIndicator(color: Colors.black),
              ),
              error: (error, stackTrace) => const Center(
                key: ValueKey('error'),
                child: CircularProgressIndicator(color: Colors.black),
              ),
            );
          },
          loading: () => const Center(
            key: ValueKey('loading_session'),
            child: CircularProgressIndicator(color: Colors.black),
          ),
          error: (error, stackTrace) => LoginScreen(
            key: const ValueKey('login_error'),
            onSignInGoogle: _signInWithGoogle,
            onSignInApple: _showAppleSignIn ? _signInWithApple : null,
          ),
        ),
      ),
    );
  }
}
