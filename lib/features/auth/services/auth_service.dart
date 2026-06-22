import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/dinus_email_parser.dart';
import '../../../core/utils/env.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;
  static const String _loginTimeKey = 'login_timestamp';

  /// Sign in with email and password via Supabase
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.session != null) {
      await _saveLoginTime();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('USER_ID', response.user!.id);
      await handleAfterLogin();
    }
    return response;
  }

  /// Sign up with email and password via Supabase (sends OTP if email confirmations are enabled)
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    appLog('DEBUG: Signing up user $email');
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    return response;
  }

  /// Verify OTP sent to email during Sign Up
  static Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
  }) async {
    appLog('DEBUG: Verifying OTP for $email');
    final response = await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );

    if (response.session != null) {
      await _saveLoginTime();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('USER_ID', response.user!.id);
      await handleAfterLogin();
    }
    return response;
  }

  /// Sign in with Google via Supabase idToken flow (google_sign_in v6)
  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      final webClientId = Env.googleWebClientId;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        appLog('DEBUG: Google Sign-In cancelled by user');
        return null;
      }

      appLog('DEBUG: Google User: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      appLog('DEBUG: idToken: ${idToken != null ? "exists" : "null"}');
      appLog('DEBUG: accessToken: ${accessToken != null ? "exists" : "null"}');

      if (idToken == null) {
        throw Exception('Google Sign-In failed: idToken is null');
      }

      appLog('DEBUG: Signing into Supabase with idToken');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.session != null) {
        await _saveLoginTime();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('USER_ID', response.user!.id);
        await handleAfterLogin();
      }
      return response;
    } catch (e) {
      appLog('DEBUG: Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Handle data insertion into profiles and pelamar tables after successful login
  static Future<void> handleAfterLogin() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    appLog('DEBUG: Handling post-login data for user: ${user.email}');

    try {
      final email = user.email?.toLowerCase() ?? '';
      final parsedData = DinusEmailParser.parse(email);
      final fullName = user.userMetadata?['full_name'] ?? '';
      final avatarUrl = user.userMetadata?['avatar_url'] ?? '';

      // 1. Ensure Profile exists
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'email': email,
        'role': 'pelamar',
        'full_name': fullName,
      });

      // 2. Ensure Pelamar record exists
      final pelamar = await _supabase
          .from('pelamar')
          .select()
          .eq('pelamar_id', user.id)
          .maybeSingle();

      if (pelamar == null) {
        appLog('DEBUG: Creating missing pelamar record');
        await _supabase.from('pelamar').insert({
          'pelamar_id': user.id,
          'email': email,
          'nama_lengkap': fullName,
          'foto_profil': avatarUrl,
          'nim': parsedData['nim'],
          'bidang': parsedData['bidang'],
        });
      } else {
        appLog('DEBUG: Pelamar record already exists');
        // Update NIM/Bidang if they are currently null
        if (pelamar['nim'] == null || pelamar['bidang'] == null) {
           await _supabase.from('pelamar').update({
            if (pelamar['nim'] == null) 'nim': parsedData['nim'],
            if (pelamar['bidang'] == null) 'bidang': parsedData['bidang'],
          }).eq('pelamar_id', user.id);
        }
      }

      appLog('DEBUG: post-login data handling completed successfully.');
    } catch (e) {
      appLog('DEBUG: Error in handleAfterLogin: $e');
    }
  }

  /// Save current time as login timestamp
  static Future<void> _saveLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);
    appLog('DEBUG: Login time saved');
  }

  /// Check if the session is older than 3 days
  static Future<void> checkSessionAge() async {
    if (currentSession == null) return;

    final prefs = await SharedPreferences.getInstance();
    final loginTimestamp = prefs.getInt(_loginTimeKey);

    if (loginTimestamp != null) {
      final loginDate = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
      final difference = DateTime.now().difference(loginDate).inDays;

      appLog('DEBUG: Session age: $difference days');

      if (difference >= 3) {
        appLog('DEBUG: Session expired (3 days limit). Logging out...');
        await signOut();
      }
    } else {
      // If no timestamp found but session exists, save it now as fallback
      await _saveLoginTime();
    }
  }

  /// Sign out from both Supabase and Google
  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _supabase.auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginTimeKey);
    await prefs.remove('USER_ID');
  }

  /// Get current session
  static Session? get currentSession => _supabase.auth.currentSession;

  /// Get current user
  static User? get currentUser => _supabase.auth.currentUser;
}
