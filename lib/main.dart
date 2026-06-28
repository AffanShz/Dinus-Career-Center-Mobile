import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/colors.dart';
import 'core/utils/env.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'features/notification/services/notification_service.dart';
import 'features/notification/services/realtime_notification_service.dart';
import 'core/utils/workmanager_helper.dart';

import 'core/utils/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load and validate configuration before anything else. If the .env file is
  // missing or a required key is absent, show a clear error screen instead of
  // crashing with an opaque null-check failure.
  final String supabaseUrl;
  final String supabaseAnonKey;
  try {
    await dotenv.load(fileName: '.env');
    supabaseUrl = Env.supabaseUrl;
    supabaseAnonKey = Env.supabaseAnonKey;
  } catch (e) {
    final message = e is EnvException
        ? e.message
        : 'Gagal memuat file .env. Pastikan file .env tersedia di root project. ($e)';
    runApp(ConfigErrorApp(message: message));
    return;
  }

  // Inisialisasi locale Indonesia untuk format tanggal
  await initializeDateFormatting('id_ID', null);

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // Check if session is older than 3 days (must happen before reading session)
  await AuthService.checkSessionAge();

  final initialSession = AuthService.currentSession;

  runApp(MainApp(initialSession: initialSession));

  // Defer non-critical initialization to after the first frame renders.
  // This prevents blocking the main thread and avoids ANR crashes.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Save credentials for the WorkManager background task isolate
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

    // Initialize WorkManager
    WorkManagerHelper.init();
    WorkManagerHelper.registerTask();
  });
}

final supabase = Supabase.instance.client;

class MainApp extends StatefulWidget {
  final Session? initialSession;

  const MainApp({super.key, this.initialSession});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AuthService.checkSessionAge();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
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
          onSurface: AppColors.onSurface,
        ),
      ),
      home: SplashScreen(initialSession: widget.initialSession),
    );
  }
}

/// Fallback app shown when required configuration (.env) is missing or invalid.
/// Replaces the previous behavior of crashing on a null-check at startup.
class ConfigErrorApp extends StatelessWidget {
  final String message;

  const ConfigErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.primary, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Konfigurasi Tidak Lengkap',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
