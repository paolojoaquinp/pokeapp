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
    required this.pokemonName,
  });

  final String pokemonName;

  @override
  List<Object> get props => [pokemonName];  
}




