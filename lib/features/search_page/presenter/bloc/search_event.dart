part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}


class SearchInitialEvent extends SearchEvent {
  const SearchInitialEvent();

  @override
  List<Object> get props => [];
}


class SearchPokemonEvent extends SearchEvent {
  const SearchPokemonEvent({required this.pokemonRequestName});

  final String pokemonRequestName;

  @override
  List<Object> get props => [pokemonRequestName];
}

class SearchTextChangedEvent extends SearchEvent {
  const SearchTextChangedEvent({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}