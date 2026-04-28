import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';

class GreetingSection extends StatelessWidget {
  final String userName;

  const GreetingSection({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Hi, $userName! ',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            children: const [
              TextSpan(text: '👋', style: TextStyle(fontSize: 28))
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Siap untuk membangun karir impianmu?',
          style: TextStyle(fontSize: 15, color: Colors.blueGrey[600]),
        ),
      ],
    );
  }
}
