import 'package:cine_tracker/models/show.dart';
import 'package:cine_tracker/repositories/preferences_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Déclaration d'un "Cubit" pour stocker la liste d'entreprise
class ShowCubit extends Cubit<List<Show>> {
  final PreferencesRepository preferencesRepository;

  /// Constructeur + initialisation du Cubit avec un tableau vide d'entreprise
  ShowCubit(this.preferencesRepository) : super([]);

  /// Méthode pour charger la liste d'entreprise
  Future<void> loadShows() async {
    emit(await preferencesRepository.loadShows());
  }

  /// Méthode pour ajouter une entreprise
  void addShow(Show show) {
    preferencesRepository.saveShows([...state, show]);
    emit([...state, show]);
  }

  void removeShow(Show show) {
    final updatedShows = state.where((s) => s.id != show.id).toList();
    preferencesRepository.saveShows(updatedShows);
    emit(updatedShows);
  }

  bool isShowInWatchlist(int showId) {
    return state.any((s) => s.id == showId);
  }
}
