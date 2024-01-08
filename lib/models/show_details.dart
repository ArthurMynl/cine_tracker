class ShowDetails {
  final int id;
  final String url;
  final String title;
  final String type;
  final String language;
  final List<String> genres;
  final String status;
  final int averageRuntime;
  final String premiered;
  final String ended;
  final String? officialSite;
  final String scheduleDay;
  final String scheduleTime;
  final double? rating;
  final String? posterUrl;
  final String summary;

  ShowDetails({
    required this.id,
    required this.url,
    required this.title,
    required this.type,
    required this.language,
    required this.genres,
    required this.status,
    required this.averageRuntime,
    required this.premiered,
    required this.ended,
    required this.officialSite,
    required this.rating,
    required this.summary,
    this.posterUrl,
    required this.scheduleDay,
    required this.scheduleTime,
  });

  factory ShowDetails.fromJson(Map<String, dynamic> json) {
    return ShowDetails(
      id: json['id'],
      url: json['url'],
      title: json['name'],
      type: json['type'],
      language: json['language'],
      genres: List<String>.from(json['genres']),
      status: json['status'],
      averageRuntime: json['averageRuntime'],
      premiered: json['premiered'],
      ended: json['ended'],
      officialSite: json['officialSite'],
      rating: json['rating'],
      summary: json['summary'],
      posterUrl: json['image']['medium'],
      scheduleDay: json['schedule']['days'][0],
      scheduleTime: json['schedule']['time'],
    );
  }

  @override
  String toString() {
    return 'ShowDetails{id: $id, url: $url, title: $title, type: $type, language: $language, genres: $genres, status: $status, averageRuntime: $averageRuntime, premiered: $premiered, ended: $ended, officialSite: $officialSite, scheduleDay: $scheduleDay, scheduleTime: $scheduleTime, rating: $rating, posterUrl: $posterUrl, summary: $summary}';
  }
}
