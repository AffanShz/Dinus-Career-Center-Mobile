import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Thrown when a required environment variable is missing or empty.
///
/// Carries a human-readable [message] so the UI can show a clear reason
/// instead of the app crashing with an opaque null-check error.
class EnvException implements Exception {
  final String message;
  const EnvException(this.message);

  @override
  String toString() => 'EnvException: $message';
}

/// Centralized, null-safe access to environment variables loaded from `.env`.
///
/// Use [require] instead of `dotenv.env['KEY']!` so a missing key surfaces a
/// clear, actionable error rather than a runtime crash.
class Env {
  Env._();

  /// Returns the value for [key], or throws [EnvException] if it is missing
  /// or blank. Use for variables the app cannot run without.
  static String require(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.trim().isEmpty) {
      throw EnvException(
        'Konfigurasi "$key" tidak ditemukan di file .env. '
        'Pastikan file .env ada di root project dan memuat $key. '
        'Lihat .env.example untuk daftar key yang dibutuhkan.',
      );
    }
    return value;
  }

  // --- Required keys ---
  static String get supabaseUrl => require('SUPABASE_URL');
  static String get supabaseAnonKey => require('SUPABASE_ANON_KEY');
  static String get googleWebClientId => require('GOOGLE_WEB_CLIENT_ID');
  static String get googleAndroidClientId => require('GOOGLE_ANDROID_CLIENT_ID');
}
