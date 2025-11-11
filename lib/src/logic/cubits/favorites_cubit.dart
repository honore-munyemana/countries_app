import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/favorites_service.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteCca2Codes;
  FavoritesLoaded(this.favoriteCca2Codes);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService service;

  FavoritesCubit(this.service) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    try {
      emit(FavoritesLoading());
      final list = await service.getFavorites();
      emit(FavoritesLoaded(list.toSet()));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String cca2) async {
    if (state is FavoritesLoaded) {
      final current = Set<String>.from((state as FavoritesLoaded).favoriteCca2Codes);
      if (current.contains(cca2)) {
        current.remove(cca2);
      } else {
        current.add(cca2);
      }
      emit(FavoritesLoaded(current));
    }
    await service.toggleFavorite(cca2);
    // Ensure state is in sync with storage
    await loadFavorites();
  }

  bool isFavoriteSync(String cca2) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favoriteCca2Codes.contains(cca2);
    }
    return false;
  }
}


