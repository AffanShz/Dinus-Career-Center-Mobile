import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/dinus_email_parser.dart';

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
      await handleAfterLogin();
    }
    return response;
  }

  /// Sign in with Google via Supabase idToken flow (google_sign_in v6)
  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
      print('DEBUG: Starting Google Sign-In with webClientId: $webClientId');

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('DEBUG: Google Sign-In cancelled by user');
        return null;
      }

      print('DEBUG: Google User: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      print('DEBUG: idToken: ${idToken != null ? "exists" : "null"}');
      print('DEBUG: accessToken: ${accessToken != null ? "exists" : "null"}');

      if (idToken == null) {
        throw Exception('Google Sign-In failed: idToken is null');
      }

      print('DEBUG: Signing into Supabase with idToken');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.session != null) {
        await _saveLoginTime();
        await handleAfterLogin();
      }
      return response;
    } catch (e) {
      print('DEBUG: Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Handle data insertion into profiles and pelamar tables after successful login
  static Future<void> handleAfterLogin() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    print('DEBUG: Handling post-login data for user: ${user.email}');

    try {
      final email = user.email?.toLowerCase() ?? '';
      final isStudent = email.endsWith('@mhs.dinus.ac.id');
      final parsedData = DinusEmailParser.parse(email);

      // Check if profile already exists
      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        print('DEBUG: New user detected, inserting into profiles and pelamar');

        // Auto-assign 'pelamar' role for mhs.dinus.ac.id users
        final assignedRole = isStudent ? 'pelamar' : 'pelamar';

        await _supabase.from('profiles').upsert({
          'id': user.id,
          'email': email,
          'role': assignedRole,
          'full_name': user.userMetadata?['full_name'] ?? '',
        });

        await _supabase.from('pelamar').upsert({
          'pelamar_id': user.id,
          'email': email,
          'nama_lengkap': user.userMetadata?['full_name'] ?? '',
          'foto_profil': user.userMetadata?['avatar_url'] ?? '',
          'nim': parsedData['nim'],
          'bidang': parsedData['bidang'],
        });

        print(
          'DEBUG: Successfully inserted user data with role $assignedRole and parsed NIM: ${parsedData['nim']}',
        );
      } else {
        print(
          'DEBUG: User profile already exists. Updating existing data if necessary.',
        );

        // Ensure student accounts have 'pelamar' role
        if (isStudent && profile['role'] != 'pelamar') {
          await _supabase
              .from('profiles')
              .update({'role': 'pelamar'})
              .eq('id', user.id);
          print(
            'DEBUG: Updated existing user role to pelamar (student detected)',
          );
        }

        // For existing users, update NIM and Bidang if they were parsed successfully
        if (parsedData['nim'] != null) {
          final existingPelamar = await _supabase
              .from('pelamar')
              .select('nim, bidang')
              .eq('pelamar_id', user.id)
              .maybeSingle();

          if (existingPelamar != null &&
              (existingPelamar['nim'] == null ||
                  existingPelamar['bidang'] == null)) {
            await _supabase
                .from('pelamar')
                .update({
                  'nim': parsedData['nim'],
                  'bidang': parsedData['bidang'],
                })
                .eq('pelamar_id', user.id);
            print(
              'DEBUG: Updated existing user with parsed NIM: ${parsedData['nim']}',
            );
          }
        }
      }
    } catch (e) {
      print('DEBUG: Error in handleAfterLogin: $e');
    }
  }

  /// Save current time as login timestamp
  static Future<void> _saveLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_loginTimeKey, DateTime.now().millisecondsSinceEpoch);
    print('DEBUG: Login time saved');
  }

  /// Check if the session is older than 3 days
  static Future<void> checkSessionAge() async {
    if (currentSession == null) return;

    final prefs = await SharedPreferences.getInstance();
    final loginTimestamp = prefs.getInt(_loginTimeKey);

    if (loginTimestamp != null) {
      final loginDate = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
      final difference = DateTime.now().difference(loginDate).inDays;

      print('DEBUG: Session age: $difference days');

      if (difference >= 3) {
        print('DEBUG: Session expired (3 days limit). Logging out...');
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
  }

  /// Get current session
  static Session? get currentSession => _supabase.auth.currentSession;

  /// Get current user
  static User? get currentUser => _supabase.auth.currentUser;
}
