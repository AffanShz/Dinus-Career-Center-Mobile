class Job {
  final String title;
  final String company;
  final String location;
  final List<String> tags;

  Job({
    required this.title,
    required this.company,
    required this.location,
    required this.tags,
  });

  Job copyWith() {
    return Job(
      title: title,
      company: company,
      location: location,
      tags: tags,
    );
  }
}
