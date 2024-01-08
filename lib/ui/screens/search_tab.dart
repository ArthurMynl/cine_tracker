import 'dart:async';

import 'package:cine_tracker/repositories/tv_maze_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_tracker/models/show.dart'; // Import the Show model
import 'package:cine_tracker/ui/widgets/show_widget.dart'; // Import the ShowWidget

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});
  @override
  SearchTabState createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  List<Show> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final TvMaveRepository _repository = TvMaveRepository();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _searchShows(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        var searchResults = await _repository.getShows(query);
        setState(() {
          _searchResults = searchResults;
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Shows',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _searchShows('');
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                onChanged: _searchShows,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ShowWidget(show: _searchResults[index]);
                },
              ),
            ),
          ],
        ));
  }
}
