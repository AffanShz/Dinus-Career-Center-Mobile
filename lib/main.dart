import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/screens/login.dart';
import 'features/auth/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('DEBUG: App Starting...');
  await dotenv.load(fileName: '.env');
  // Inisialisasi locale Indonesia untuk format tanggal
  await initializeDateFormatting('id_ID', null);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Check if session is older than 3 days
  await AuthService.checkSessionAge();

  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
