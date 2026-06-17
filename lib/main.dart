import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/colors.dart';
import 'features/auth/screens/login.dart';
import 'features/home/screens/main_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'features/notification/services/notification_service.dart';
import 'features/notification/services/realtime_notification_service.dart';
// flutter_background_service disabled — conflicts with android plugin isolate guard
// import 'features/notification/services/notification_background_service.dart';
import 'core/utils/workmanager_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('DEBUG: App Starting...');
  await dotenv.load(fileName: '.env');

  // Inisialisasi locale Indonesia untuk format tanggal
  await initializeDateFormatting('id_ID', null);

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // Check if session is older than 3 days (must happen before reading session)
  await AuthService.checkSessionAge();

  final initialSession = AuthService.currentSession;

  runApp(MainApp(initialSession: initialSession));

  // Defer non-critical initialization to after the first frame renders.
  // This prevents blocking the main thread and avoids ANR crashes.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Save credentials for background service
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SUPABASE_URL', supabaseUrl);
    await prefs.setString('SUPABASE_ANON_KEY', supabaseAnonKey);

    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await prefs.setString('USER_ID', user.id);
    }

    // Initialize Notification Services
    final notificationService = NotificationService();
    await notificationService.init();
    await notificationService.requestPermissions();

    // Initialize Realtime Notification Service for foreground
    final realtimeService = RealtimeNotificationService();
    realtimeService.listenToAuthChanges();

    // flutter_background_service disabled — handled by WorkManager instead

    // Initialize WorkManager
    WorkManagerHelper.init();
    WorkManagerHelper.registerTask();
  });
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  final Session? initialSession;

  const MainApp({super.key, this.initialSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.manropeTextTheme(Theme.of(context).textTheme)
            .apply(
              bodyColor: AppColors.onSurface,
              displayColor: AppColors.onSurface,
            ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          onSurface: AppColors.onSurface,
        ),
      ),
      home: initialSession != null ? const MainScreen() : const Login(),
    );
  }
}
