import 'package:cine_tracker/blocs/show_cubit.dart';
import 'package:cine_tracker/repositories/preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_tracker/ui/screens/search_tab.dart';
import 'package:cine_tracker/ui/screens/watchlist_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Pour pouvoir utiliser les SharePreferences avant le runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Instanciation du Cubit
  final ShowCubit showCubit = ShowCubit(PreferencesRepository());

  // Chargement des entreprises
  showCubit.loadShows();

  runApp(BlocProvider<ShowCubit>(
    create: (_) => showCubit,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineLister',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF57CC99)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark, // <-- the only line added
            seedColor: const Color.fromARGB(255, 89, 87, 204)),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const WatchlistTab(
      watchlist: [],
    ),
    const SearchTab(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
