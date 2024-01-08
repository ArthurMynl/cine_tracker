import 'dart:convert';
import 'package:cine_tracker/models/show.dart';
import 'package:cine_tracker/models/show_details.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://api.tvmaze.com';

class TvMaveRepository {
  Future<List<Show>> getShows(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl/search/shows?q=$query'));

    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);

      List<Show> shows = responseBody.map<Show>((show) {
        return Show(
          id: show["show"]['id'],
          title: show["show"]['name'],
          posterUrl: show["show"]['image'] != null
              ? show["show"]['image']['medium']
              : null,
          year: show["show"]['premiered'] != null
              ? int.parse(show["show"]['premiered'].split('-')[0])
              : 0,
        );
      }).toList();

      return shows;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  Future<ShowDetails> getShow(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/shows/$id'));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      String days =
          (responseBody['schedule']['days'] as List<dynamic>).join(', ');
      var showDetails = ShowDetails(
        id: responseBody['id'],
        title: responseBody['name'],
        posterUrl: responseBody['image'] != null
            ? responseBody['image']['original']
            : null,
        summary: responseBody['summary'],
        rating: responseBody['rating']?['average']?.toDouble(),
        genres: responseBody['genres'].cast<String>(),
        status: responseBody['status'],
        url: responseBody['url'],
        type: responseBody['type'],
        language: responseBody['language'],
        averageRuntime: responseBody['averageRuntime'],
        premiered: responseBody['premiered'],
        officialSite: responseBody['officialSite'],
        scheduleDay: days,
        scheduleTime: responseBody['schedule']['time'],
        ended: responseBody['ended'] ?? "Running",
      );

      return showDetails;
    } else {
      throw Exception('Failed to load show');
    }
  }
}
