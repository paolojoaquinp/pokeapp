part of 'pokemon_details_bloc.dart';

sealed class PokemonDetailsEvent extends Equatable {
  const PokemonDetailsEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends PokemonDetailsEvent {
  const InitialEvent();

  @override
  List<Object> get props => [];  
}

class PokemonDetailsInitialEvent extends PokemonDetailsEvent {
  const PokemonDetailsInitialEvent({
    required this.urlDetailPokemon,
  });

  final String urlDetailPokemon;

  @override
  List<Object> get props => [urlDetailPokemon];  
}




