import 'package:equatable/equatable.dart';

class PokemonCardState extends Equatable {
  final String id;
  final bool isFavorite;

  const PokemonCardState({required this.id, required this.isFavorite});

  PokemonCardState copyWith({bool? isFavorite}) {
    return PokemonCardState(
      id: id,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [id, isFavorite];
}