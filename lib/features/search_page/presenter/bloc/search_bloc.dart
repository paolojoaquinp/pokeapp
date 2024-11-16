import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.pokemonRepository})
      : controller = TextEditingController(),
        super(const SearchInitialState()) {
    on<SearchInitialEvent>(_onSearchInitialEvent);
    on<SearchPokemonEvent>(_onSearchPokemonEvent);
    on<SearchTextChangedEvent>(_onSearchTextChangedEvent);
  }

  final PokemonRepository pokemonRepository;
  final TextEditingController controller;
  List<dynamic>? _originalPokemons;


  Future<void> _onSearchInitialEvent(
      SearchInitialEvent event, Emitter<SearchState> emit) async {
    controller.clear();
    emit(const SearchLoadingState());
    final result = await pokemonRepository.getPokemons();
    result.when(
      ok: (data) {
        if (data.results!.isNotEmpty) {
          _originalPokemons = data.results;
          emit(SearchSuggestionLoadedState(pokemons: data));
        }
      },
      err: (err) {
        emit(SearchErrorState(error: err.toString()));
      },
    );
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

  Future<void> _onSearchTextChangedEvent(
      SearchTextChangedEvent event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchSuggestionLoadedState(
        pokemons: PokemonResponse(
          count: _originalPokemons!.length,
          results: _originalPokemons!, next: '',
        ),
      ));
      return;
    }
    if (_originalPokemons == null || _originalPokemons!.isEmpty) {
      return; // No hay datos para filtrar
    }

    final filteredPokemons = _originalPokemons!.where((pokemon) {
      final name = pokemon['name']?.toLowerCase() ?? '';
      return name.contains(event.query.toLowerCase());
    }).toList();
    if (filteredPokemons.isEmpty) {
      emit(const SearchErrorState(error: 'No Pokémon found for the given query.'));
    } else {
      emit(SearchSuggestionLoadedState(
        pokemons: PokemonResponse(
          count: filteredPokemons.length,
          results: filteredPokemons,
          next: '',
        ),
      ));
    }
  }
}