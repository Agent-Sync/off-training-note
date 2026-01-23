import 'package:flutter/material.dart';
import 'package:off_training_note/widgets/dotted_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onSignIn});

  final Future<void> Function() onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: DottedBackgroundPainter()),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Logo Mark
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sticky_note_2_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    const Text(
                      'オフトレノート',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    Text(
                      'スノーボードのオフトレ記録を\nもっと手軽に、もっと楽しく。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => onSignIn(),
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text(
                          'Googleでログイン',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Terms Text
                    Text(
                      'ログインすることで、利用規約とプライバシーポリシーに\n同意したものとみなされます。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
