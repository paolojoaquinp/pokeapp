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
  const FavoritesLoadedState({
    required this.pokemons
  });

  final List<Pokemon> pokemons;

  @override
  List<Object> get props => [pokemons];
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