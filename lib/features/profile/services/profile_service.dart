import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../../../core/utils/dinus_email_parser.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  Future<UserProfile> fetchUserProfile() async {
    final user = _supabase.auth.currentUser;
    final String email = user?.email ?? '';
    final String nameFromAuth = user?.userMetadata?['full_name'] ?? 'User DCC';
    final String photoFromAuth = user?.userMetadata?['avatar_url'] ?? '';

    // Always parse email for NIM & bidang as fallback
    final parsed = DinusEmailParser.parse(email);
    final String? nimFromEmail = parsed['nim'];
    final String? bidangFromEmail = parsed['bidang'];

    try {
      final pelamarData = await _supabase
          .from('pelamar')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (pelamarData != null) {
        final profile = UserProfile.fromMap(pelamarData);
        // If nim or bidang not saved in DB yet, use parsed values as fallback
        return profile.copyWith(
          nim: profile.nim ?? nimFromEmail,
          bidang: profile.bidang ?? bidangFromEmail,
        );
      }

      // Fallback: user not in DB yet
      return UserProfile(
        id: user?.id ?? '',
        email: email,
        name: nameFromAuth,
        photoUrl: photoFromAuth,
        nim: nimFromEmail,
        bidang: bidangFromEmail,
      );
    } catch (e) {
      print('Error fetching profile from Supabase: $e');
      return UserProfile(
        id: user?.id ?? '',
        email: email,
        name: nameFromAuth,
        photoUrl: photoFromAuth,
        nim: nimFromEmail,
        bidang: bidangFromEmail,
      );
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      await _supabase
          .from('pelamar')
          .update(profile.toMap())
          .eq('pelamar_id', profile.id);

      // Also update profiles table for consistency if needed
      await _supabase
          .from('profiles')
          .update({'full_name': profile.name})
          .eq('id', profile.id);

      print('DEBUG: Profile updated successfully');
    } catch (e) {
      print('DEBUG: Error updating profile: $e');
      rethrow;
    }
  }
}
