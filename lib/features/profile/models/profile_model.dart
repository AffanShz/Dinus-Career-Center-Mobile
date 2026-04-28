class Experience {
  final String date;
  final String title;
  final String company;
  final String description;
  final bool isActive;

  Experience({
    required this.date,
    required this.title,
    required this.company,
    required this.description,
    required this.isActive,
  });
}

class Education {
  final String institution;
  final String degree;
  final String period;
  final String location;

  Education({
    required this.institution,
    required this.degree,
    required this.period,
    required this.location,
  });
}

class UserProfile {
  final String name;
  final String major;
  final String university;
  final String batch;
  final String gpa;
  final List<String> skills;
  final List<Experience> experiences;
  final List<Education> education;

  UserProfile({
    required this.name,
    required this.major,
    required this.university,
    required this.batch,
    required this.gpa,
    required this.skills,
    required this.experiences,
    required this.education,
  });
}
