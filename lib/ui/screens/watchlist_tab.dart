import 'package:cine_tracker/blocs/show_cubit.dart';
import 'package:cine_tracker/models/show.dart';
import 'package:cine_tracker/ui/widgets/show_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTab extends StatelessWidget {
  final List<Show> watchlist;

  const WatchlistTab({Key? key, required this.watchlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
      ),
      body: BlocBuilder<ShowCubit, List<Show>>(
        builder: (context, watchlist) {
          return ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              return ShowWidget(show: watchlist[index]);

              
            },
          );
        },
      ),
    );
  }
}
