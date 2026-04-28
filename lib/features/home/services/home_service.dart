import '../models/job_model.dart';
import '../models/event_model.dart';

class HomeService {
  Future<Map<String, dynamic>> fetchHomeData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    return {
      'userName': 'Antek Antek ASENG',
      'profileCompleteness': 0.75,
      'recommendedJobs': [
        Job(
          title: 'Product Designer',
          company: 'Google Inc.',
          location: 'Mountain View, CA',
          tags: ['FULLTIME', 'Rp50Jt - Rp60Jt'],
        ),
        Job(
          title: 'Frontend Developer',
          company: 'Microsoft',
          location: 'Redmond, WA',
          tags: ['REMOTE', 'Rp40Jt - Rp50Jt'],
        ),
      ],
      'upcomingEvent': Event(
        title: 'Tech Career Expo 2024',
        date: 'Oct 24, 2024',
        time: '10:00 AM',
        type: 'LIVE WEBINAR',
      ),
    };
  }
}
