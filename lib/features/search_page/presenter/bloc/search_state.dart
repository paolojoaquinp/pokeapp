part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitialState extends SearchState {
  const SearchInitialState();

  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();

  @override
  List<Object> get props => [];
}

class SearchSuggestionLoadedState extends SearchState {
  const SearchSuggestionLoadedState({required this.pokemons});

  final PokemonResponse pokemons;

  @override
  List<Object> get props => [pokemons];
}

class SearchLoadedState extends SearchState {
  const SearchLoadedState({required this.pokemon});

  final Pokemon pokemon;

  @override
  List<Object> get props => [pokemon];
}

class SearchErrorState extends SearchState {
  const SearchErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}
