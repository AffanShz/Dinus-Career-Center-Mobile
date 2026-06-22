import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_state.dart';
import 'package:dcc_mobile/features/auth/widgets/auth_password_field.dart';
import 'package:dcc_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:dcc_mobile/features/auth/screens/otp.dart';
import 'package:dcc_mobile/core/utils/dinus_email_parser.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_event.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpRequired) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => OtpScreen(email: state.email),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(32.0),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo UDINUS
                Image.asset(
                  'assets/images/udinus.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.school,
                    size: 80,
                    color: Color(0xFF0F4C81),
                  ),
                ),
                const SizedBox(height: 16),

                // Judul
                Text(
                  'Registrasi Akun',
                  style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Daftar untuk mengakses fitur Dinus Career Center.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                AuthTextField(
                  label: 'NAMA LENGKAP',
                  prefixIcon: Icons.badge_outlined,
                  hintText: 'Nama Lengkap',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),

                AuthTextField(
                  label: 'EMAIL',
                  prefixIcon: Icons.email_outlined,
                  hintText: 'NIM@mhs.dinus.ac.id',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                AuthPasswordField(
                  label: 'KATA SANDI',
                  controller: _passwordController,
                  hintText: 'Password',
                ),
                const SizedBox(height: 16),

                AuthPasswordField(
                  label: 'KONFIRMASI KATA SANDI',
                  controller: _confirmPasswordController,
                  hintText: 'Konfirmasi Password',
                ),
                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4C81),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() == true) {
                              if (_passwordController.text != _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Konfirmasi password tidak cocok!'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              final emailInput = _emailController.text.trim();
                              final parsedEmail = DinusEmailParser.toEmail(emailInput) ?? emailInput;

                              context.read<AuthBloc>().add(
                                RegisterRequested(
                                  email: parsedEmail,
                                  password: _passwordController.text,
                                  fullName: _nameController.text.trim(),
                                ),
                              );
                            }
                          },
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Daftar Sekarang',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF0F4C81),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
