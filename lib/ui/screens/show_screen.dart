import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_tracker/blocs/show_cubit.dart';
import 'package:cine_tracker/models/show.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cine_tracker/repositories/tv_maze_repository.dart';
import 'package:cine_tracker/models/show_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShowScreen extends StatefulWidget {
  final int showId;

  const ShowScreen({Key? key, required this.showId}) : super(key: key);

  @override
  ShowScreenState createState() => ShowScreenState();
}

class ShowScreenState extends State<ShowScreen> {
  late ShowDetails show;
  bool isLoading = true;
  bool hasError = false;
  bool isInWatchlist = false;
  String shortenedName = '';

  @override
  void initState() {
    super.initState();
    _loadShow();
    isInWatchlist = context.read<ShowCubit>().isShowInWatchlist(widget.showId);
  }

  String _getScheduleString(String scheduleDay, String scheduleTime) {
    if (scheduleDay.isEmpty && scheduleTime.isEmpty) {
      return 'N/A';
    } else if (scheduleDay.isNotEmpty && scheduleTime.isEmpty) {
      return 'Every $scheduleDay';
    } else {
      return 'Every $scheduleDay at $scheduleTime';
    }
  }

  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  void _loadShow() async {
    try {
      var showDetails = await TvMaveRepository().getShow(widget.showId);
      if (!mounted) return;
      setState(() {
        show = showDetails;
        shortenedName = _getShortenedName(show.officialSite);
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error loading show details'),
        ),
      );
    }
  }

  String _getShortenedName(String? url) {
    if (url == null) return 'Not available';
    Uri uri = Uri.parse(url);
    return uri.host
        .replaceAll('www.', ''); // Removes 'www.' and returns the domain name
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      // Handle the error or show a message
    }
  }

  void _toggleWatchlist() {
    final cubit = context.read<ShowCubit>();
    if (isInWatchlist) {
      cubit.removeShow(Show(
          id: show.id,
          title: show.title,
          posterUrl: show.posterUrl,
          year: int.parse(show.premiered.substring(0, 4))));
    } else {
      cubit.addShow(Show(
          id: show.id,
          title: show.title,
          posterUrl: show.posterUrl,
          year: int.parse(show.premiered.substring(0, 4))));
    }
    setState(() {
      isInWatchlist = !isInWatchlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 50, color: Colors.red),
              SizedBox(height: 16),
              Text('Failed to load show details',
                  style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 500,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Assuming a standard aspect ratio for the poster, calculate height
                return FlexibleSpaceBar(
                  background: show.posterUrl != null
                      ? Hero(
                          tag: show.id,
                          child: CachedNetworkImage(
                            imageUrl: show.posterUrl!,
                            width: 50,
                            height: 50,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image),
                            fit: BoxFit.fitWidth,
                          ))
                      : const Icon(Icons.image, size: 250),
                );
              },
            ),
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: _toggleWatchlist,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Wrap(
                        spacing: 10,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  show.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow
                                      .ellipsis, // To handle long text
                                ),
                              ), // This will push the elements to the edges
                              IconButton(
                                icon: Icon(
                                  isInWatchlist
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                                onPressed: _toggleWatchlist,
                              ),
                            ],
                          ),
                        ])),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.language_outline, size: 16),
                      const SizedBox(width: 5),
                      Flexible(
                          child: Text(
                        'Language: ${show.language}',
                        style: const TextStyle(fontSize: 16),
                      ))
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.pricetags_outline, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        // Use Expanded instead of Flexible
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align text to the start
                          children: [
                            Text(
                              'Genres: ${show.genres.join(', ')}',
                              style: const TextStyle(fontSize: 16),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.information_circle_outline, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Status: ${show.status}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.hourglass_outline, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Average Runtime: ${show.averageRuntime} minutes',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.calendar_outline, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Premiered: ${show.premiered}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.calendar_outline, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Ended: ${show.ended}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.link_outline, size: 16),
                      const SizedBox(width: 5),
                      Text.rich(
                        TextSpan(
                          text: 'Official Site: ',
                          style: const TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: shortenedName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL(show.officialSite),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.star_outline, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Rating: ${show.rating ?? 'Not available'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Ionicons.time_outline, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Schedule: ${_getScheduleString(show.scheduleDay, show.scheduleTime)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]),
                  ),
                ),
                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16.0), // Padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Summary:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            height: 8), // Space between title and content
                        Text(
                            _removeHtmlTags(show.summary).isNotEmpty
                                ? _removeHtmlTags(show.summary)
                                : 'No summary available',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
