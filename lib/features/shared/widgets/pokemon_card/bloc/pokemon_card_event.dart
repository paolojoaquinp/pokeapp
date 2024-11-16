import 'package:equatable/equatable.dart';



sealed class PokemonCardEvent extends Equatable {
  const PokemonCardEvent();

  @override
  List<Object> get props => [];
}

class PokemonCardInitialEvent extends PokemonCardEvent {
  const PokemonCardInitialEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends PokemonCardEvent {
  const AddFavoriteEvent({required this.idPokemon});

  final String idPokemon;

  @override
  List<Object> get props => [idPokemon];
}

class RemoveFavoriteEvent extends PokemonCardEvent {
  const RemoveFavoriteEvent({required this.idPokemon});

  final String idPokemon;

  @override
  List<Object> get props => [idPokemon];
}