import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:dcc_mobile/features/auth/widgets/auth_password_field.dart';
import 'package:dcc_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:dcc_mobile/features/home/screens/main_screen.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6B8DD6), Color(0xFF4A6FA5), Color(0xFF2D4F8A)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 32.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              'Welcome to DCC Mobile',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headingLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Shape your future career at UDINUS',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 40),
                            Container(
                              padding: const EdgeInsets.all(32.0),
                              height: 494,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DCC SSO Login',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Please sign in with your student \ncredentials',
                                    style: AppTextStyles.bodyExtraSmall,
                                  ),
                                  const SizedBox(height: 24),
                                  AuthTextField(
                                    label: 'USERNAME',
                                    prefixIcon: Icons.person_outline,
                                    hintText: 'A11.202X.XXXXX',
                                  ),
                                  const SizedBox(height: 16),
                                  AuthPasswordField(),
                                  const SizedBox(height: 8.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Forgot Password?',
                                        style: AppTextStyles.bodyExtraSmallBold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryLight,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ==
                                            true) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScreen(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Login',
                                            style: AppTextStyles.bodySmallBold,
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '© 2024 Dinus Career Center. All Rights Reserved.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyExtraSmallLight,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
