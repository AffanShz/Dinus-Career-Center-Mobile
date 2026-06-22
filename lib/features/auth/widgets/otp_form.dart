import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_state.dart';
import 'package:dcc_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_event.dart';
import 'package:dcc_mobile/features/home/screens/main_screen.dart';
class OtpForm extends StatefulWidget {
  final String email;
  const OtpForm({super.key, required this.email});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
            (route) => false,
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
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 64,
                  color: Color(0xFF0F4C81),
                ),
                const SizedBox(height: 16),
                Text(
                  'Verifikasi Email',
                  style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukkan kode OTP yang telah dikirimkan ke email Anda.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                AuthTextField(
                  label: '',
                  prefixIcon: Icons.lock_outline,
                  hintText: 'Kode OTP',
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4C81),
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
                                 OtpVerifyRequested(
                                   email: widget.email,
                                   token: _otpController.text.trim(),
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
                            'Verifikasi',
                            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Resend OTP logic
                  },
                  child: Text(
                    'Kirim ulang kode OTP',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF0F4C81), 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
