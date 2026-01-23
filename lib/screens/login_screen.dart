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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'オフトレノート',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Googleでログインして開始',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => onSignIn(),
                    icon: const Icon(Icons.login),
                    label: const Text('Googleでログイン'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
