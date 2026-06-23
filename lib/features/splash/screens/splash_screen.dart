import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/screens/login.dart';
import '../../home/screens/main_screen.dart';

/// Initial screen shown on launch. Displays the UDINUS logo with the
/// "Career Center" wordmark, then routes to [MainScreen] or [Login]
/// depending on whether a session is already active.
class SplashScreen extends StatefulWidget {
  final Session? initialSession;

  const SplashScreen({super.key, this.initialSession});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Hold the splash briefly so the branding is visible, then route.
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            widget.initialSession != null ? const MainScreen() : const Login(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/udinus.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'Career Center',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
