import 'dart:convert';

import 'package:cine_tracker/models/show.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  Future<void> saveShows(List<Show> shows) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> listJson = [];
    for (final Show show in shows) {
      listJson.add(jsonEncode(show.toJson()));
    }
    prefs.setStringList('shows', listJson);
  }

  Future<List<Show>> loadShows() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> listJson = prefs.getStringList('shows') ?? [];

    final List<Show> shows = [];

    for (final String json in listJson) {
      shows.add(Show.fromJson(jsonDecode(json)));
    }

    return shows;
  }
}
