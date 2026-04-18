import 'package:flutter/material.dart';
import 'features/auth/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabase_url = 'https://kjejqcgffmojneyjadzj.supabase.co';
const supabase_key =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtqZWpxY2dmZm1vam5leWphZHpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2OTg1NDgsImV4cCI6MjA5MTI3NDU0OH0.2fVh0J4E4GjmxVCzFdrEqs42JfnqI8uFvXvd23BUmLs';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabase_url, anonKey: supabase_key);
  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}
