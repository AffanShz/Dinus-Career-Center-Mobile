import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const GoogleSignInButton({super.key, required this.onPressed, this.text = 'Masuk dengan Google'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: const BorderSide(color: Colors.black12),
        ),
        onPressed: () {
          appLog('DEBUG: GoogleSignInButton pressed');
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using local asset for Google logo
            Image.asset(
              'assets/images/google.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.login, color: Colors.red);
              },
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
