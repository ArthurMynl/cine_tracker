import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_tracker/models/show.dart';
import 'package:cine_tracker/ui/screens/show_screen.dart';
import 'package:flutter/material.dart';

class ShowWidget extends StatelessWidget {
  final Show show;

  const ShowWidget({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: show.posterUrl != null
            ? Hero(
                tag: show.id,
                child: CachedNetworkImage(
                  imageUrl: show.posterUrl!,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.image),
                ))
            : const Icon(Icons.image,
                size: 50), // Display a default icon if no poster URL
        title: Text(show.title),
        subtitle: Text('Year: ${show.year}'),
        trailing: const IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: null,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowScreen(showId: show.id),
            ),
          );
        },
      ),
    );
  }
}
