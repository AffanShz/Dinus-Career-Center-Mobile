class Job {
  final String title;
  final String company;
  final String location;
  final List<String> tags;
  final bool isBookmarked;

  Job({
    required this.title,
    required this.company,
    required this.location,
    required this.tags,
    this.isBookmarked = false,
  });

  Job copyWith({bool? isBookmarked}) {
    return Job(
      title: title,
      company: company,
      location: location,
      tags: tags,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
