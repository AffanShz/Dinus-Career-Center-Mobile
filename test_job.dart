import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dcc_mobile/features/job/services/job_service.dart';
import 'package:dcc_mobile/features/job/models/job_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  final service = JobService();
  print('Fetching jobs...');
  try {
    final jobs = await service.fetchJobs();
    print('Jobs count: \${jobs.length}');
  } catch (e, stack) {
    print('Error: \$e');
    print(stack);
  }
}