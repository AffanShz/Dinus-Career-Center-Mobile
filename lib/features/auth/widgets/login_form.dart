import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_event.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_state.dart';
import 'package:dcc_mobile/features/auth/widgets/auth_password_field.dart';
import 'package:dcc_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:dcc_mobile/features/auth/widgets/google_sign_in_button.dart';
import 'package:dcc_mobile/features/home/screens/main_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
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
                ),
                const SizedBox(height: 16),
                
                // Informasi Penting
                const Text(
                  'Informasi Penting:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Silakan login menggunakan akun @dinus.ac.id Anda.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Google Login Button
                GoogleSignInButton(
                  text: 'Masuk dengan akun dinus.ac.id',
                  onPressed: state is AuthLoading
                      ? () {}
                      : () {
                          context.read<AuthBloc>().add(GoogleLoginRequested());
                        },
                ),
                
                const SizedBox(height: 24),
                
                // ATAU Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'atau login dengan akun siadin',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Email / NIM Field (Styled like image)
                AuthTextField(
                  label: '',
                  prefixIcon: Icons.person_outline,
                  hintText: 'A11.2024.12345 atau email dinus',
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                
                // Password Field
                AuthPasswordField(
                  controller: _passwordController,
                  hintText: 'Password Siadin (bukan Google)',
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4C81), // Dark blue from image
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() == true) {
                              context.read<AuthBloc>().add(
                                    LoginRequested(
                                      _emailController.text.trim(),
                                      _passwordController.text,
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
                            'Login sebagai Dinusian',
                            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
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
