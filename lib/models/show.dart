class Show {
  final int id;
  final String title;
  final int year;
  final String? posterUrl;

  Show(
      {required this.id,
      required this.title,
      required this.year,
      required this.posterUrl});

  @override
  String toString() {
    return 'Show{id: $id, title: $title, year: $year, posterUrl: $posterUrl}';
  }

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
        id: json['id'],
        title: json['title'],
        year: json['year'],
        posterUrl: json['posterUrl']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'posterUrl': posterUrl,
    };
  }
}
