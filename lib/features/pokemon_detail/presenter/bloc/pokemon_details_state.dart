part of 'pokemon_details_bloc.dart';

abstract class PokemonDetailsState extends Equatable {
  const PokemonDetailsState();
  
}

class PokemonDetailsInitialState extends PokemonDetailsState {
  const PokemonDetailsInitialState();

  @override
  List<Object> get props => [];  
}

class DetailsLoadingState extends PokemonDetailsState {
  const DetailsLoadingState();
  
  @override
  List<Object?> get props => [];  
}

class DetailsLoadedState extends PokemonDetailsState {
  const DetailsLoadedState({
    required this.pokemon,
  });

  final Pokemon pokemon;
  
  @override
  List<Object?> get props => [pokemon];
}

class DetailsErrorState extends PokemonDetailsState {
  const DetailsErrorState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}