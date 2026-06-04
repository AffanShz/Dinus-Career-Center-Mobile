import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          side: const BorderSide(color: Colors.black12),
        ),
        onPressed: () {
          print('DEBUG: GoogleSignInButton pressed');
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using network image or asset for Google logo
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
              height: 24,
              width: 24,
              cacheWidth: 72, // Roughly 3x the display size for sharpness
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.login, color: Colors.red);
              },
            ),
            const SizedBox(width: 12),
            Text(
              'Masuk dengan Google',
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
