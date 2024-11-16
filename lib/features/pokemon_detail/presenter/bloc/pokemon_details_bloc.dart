import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

part 'pokemon_details_event.dart';
part 'pokemon_details_state.dart';

class PokemonDetailsBloc extends Bloc<PokemonDetailsEvent, PokemonDetailsState> {
  PokemonDetailsBloc({
    required this.repository,
  }) : super(const PokemonDetailsInitialState()) {
    on<PokemonDetailsEvent>((event, emit) {});
    on<PokemonDetailsInitialEvent>(_onPokemonDetailsInitialEvent);
  }

  final PokemonRepository repository;

  Future<void> _onPokemonDetailsInitialEvent(event, Emitter<PokemonDetailsState> emit) async {
    final result = await repository.getPokemonsByName(event.pokemonName);
    emit(const DetailsLoadingState());
    result.when(
      ok: (data) {
        emit(DetailsLoadedState(pokemon: data));
      },
      err: (err) => {emit(DetailsErrorState(error: err.toString()))},
    );
  }
}
