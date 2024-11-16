part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();

  @override
  List<Object> get props => [];
}
class FavoritesLoadingState extends FavoritesState {
  const FavoritesLoadingState();

  @override
  List<Object> get props => [];
}

class FavoritesLoadedState extends FavoritesState {
  final List<Pokemon> pokemons;
  final Map<String, bool> favoriteStatus;

  const FavoritesLoadedState({
    required this.pokemons,
    this.favoriteStatus = const {},
  });

  @override
  List<Object> get props => [pokemons, favoriteStatus];

  FavoritesLoadedState copyWith({
    List<Pokemon>? pokemons,
    Map<String, bool>? favoriteStatus,
  }) {
    return FavoritesLoadedState(
      pokemons: pokemons ?? this.pokemons,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
    );
  }
}

class FavoritesErrorState extends FavoritesState {
  const FavoritesErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

class PokemonFavoritesInitial extends FavoritesState {}
class PokemonFavoritesClearingState extends FavoritesState {}
class PokemonFavoritesClearedState extends FavoritesState {}


