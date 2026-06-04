import 'dart:io';
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
          .eq('pelamar_id', user?.id ?? '')
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
      print('ERROR: fetchUserProfile: $e');
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
    final data = profile.toMap();
    print('DEBUG: updateProfile called for user: ${profile.id}');
    print('DEBUG: Data to upsert: $data');

    // Step 1: Upsert into pelamar table (primary save)
    try {
      await _supabase
          .from('pelamar')
          .upsert(data, onConflict: 'pelamar_id');
      print('DEBUG: pelamar upsert SUCCESS');
    } catch (e, stack) {
      print('ERROR: pelamar upsert FAILED');
      print('ERROR type: ${e.runtimeType}');
      print('ERROR message: $e');
      print('ERROR stack: $stack');
      rethrow;
    }

    // Step 2: Sync name/email to profiles table (non-blocking — won't cause save to fail)
    try {
      await _supabase
          .from('profiles')
          .upsert({
            'id': profile.id,
            'full_name': profile.name.isEmpty ? null : profile.name,
            'email': profile.email.isEmpty ? null : profile.email,
            'role': 'pelamar', // NOT NULL column — must always be provided
            'updated_at': DateTime.now().toIso8601String(),
          }, onConflict: 'id');
      print('DEBUG: profiles sync SUCCESS');
    } catch (e) {
      // Non-critical: log but don't rethrow
      print('WARN: profiles sync failed (non-critical): $e');
    }
  }

  Future<String?> uploadProfilePicture(File file) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('ERROR: uploadProfilePicture - no authenticated user');
      return null;
    }

    final String userId = user.id;
    final String extension = file.path.split('.').last.toLowerCase();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // Store as userId/timestamp.ext to organize per user
    final String filePath = '$userId/$timestamp.$extension';

    print('DEBUG: Uploading photo → bucket: foto-profil, path: $filePath');
    print('DEBUG: File size: ${await file.length()} bytes');

    try {
      await _supabase.storage.from('foto-profil').upload(
        filePath,
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      // Get public URL and append cache-buster so UI always refreshes
      final String publicUrl =
          _supabase.storage.from('foto-profil').getPublicUrl(filePath);
      final String urlWithCacheBust = '$publicUrl?t=$timestamp';

      print('DEBUG: Photo uploaded successfully: $urlWithCacheBust');
      return urlWithCacheBust;
    } catch (e) {
      print('ERROR: uploadProfilePicture FAILED: $e');
      rethrow;
    }
  }

  Future<void> deleteProfilePicture(String url) async {
    try {
      final uri = Uri.parse(url.split('?').first); // strip cache-buster
      final pathSegments = uri.pathSegments;

      // URL pattern: .../storage/v1/object/public/foto-profil/userId/filename
      // Find the index of 'foto-profil' in the path segments
      final bucketIndex = pathSegments.indexOf('foto-profil');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        // Everything after 'foto-profil' is the file path inside the bucket
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        print('DEBUG: Deleting old photo from foto-profil/$filePath');
        await _supabase.storage.from('foto-profil').remove([filePath]);
        print('DEBUG: Old photo deleted');
      }
    } catch (e) {
      print('WARN: deleteProfilePicture failed (non-critical): $e');
      // Non-critical: we can still continue even if old file delete fails
    }
  }
}
