import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
   SearchBloc({required this.pokemonRepository})
      : controller = TextEditingController(),
        super(const SearchInitialState()) {
    on<SearchInitialEvent>(_onSearchInitialEvent);
    on<SearchPokemonEvent>(_onSearchPokemonEvent);
  }

  final PokemonRepository pokemonRepository;
  final TextEditingController controller;

  Future<void> _onSearchInitialEvent(SearchInitialEvent event, Emitter<SearchState> emit) async {
    controller.clear(); 
  }



  Future<void> _onSearchPokemonEvent(event, Emitter<SearchState> emit) async {
    final requestName = event.pokemonRequestName;
    emit(const SearchLoadingState());
    final result = await pokemonRepository.getPokemonsByName(requestName);
    result.when(
      ok: (data) {
        if (data.name!.isNotEmpty) {
          emit(SearchLoadedState(pokemon: data));
        }
      },
      err: (err) {
        emit(SearchErrorState(error: err.toString()));
      },
    );
  }
}
