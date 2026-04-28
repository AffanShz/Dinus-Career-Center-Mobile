import '../models/profile_model.dart';

class ProfileService {
  Future<UserProfile> fetchUserProfile() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    return UserProfile(
      name: 'ANTEK ANTEK ASENG',
      major: 'Teknik Informatika',
      university: 'UDINUS',
      batch: '2024',
      gpa: '3.87',
      skills: [
        'React.js',
        'Tailwind CSS',
        'Python',
        'Machine Learning',
        'SQL',
        'UI Design',
        '+ 8 lainnya',
      ],
      experiences: [
        Experience(
          date: 'JULY 2024 - PRESENT',
          title: 'Fullstack Developer Intern',
          company: 'Global Tech Solutions',
          description:
              'Developing scalable web architectures and optimizing database queries for high-traffic applications.',
          isActive: true,
        ),
        Experience(
          date: 'JAN 2024 - FEB 2024',
          title: 'Web Developer',
          company: 'PT. Media Edukasi Teknologi',
          description:
              'Developing scalable web architectures and optimizing database queries for high-traffic applications.',
          isActive: false,
        ),
      ],
      education: [
        Education(
          institution: 'Universitas Dian Nuswantoro',
          degree: 'S1 Teknik Informatika',
          period: '2024 - 2028',
          location: 'Semarang, Indonesia',
        ),
      ],
    );
  }
}
