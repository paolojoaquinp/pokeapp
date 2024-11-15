import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required this.pokemonRepository}) : hivePreferences = HiveHelper(), super(FavoritesInitial()) {
    on<FavoritesEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FavoritesInitialEvent>(_onFavoritesInitialEvent);
  }

  final HiveHelper hivePreferences;
  final PokemonRepository pokemonRepository;

  Future<void> _onFavoritesInitialEvent(event, Emitter<FavoritesState> emit) async {
    List<Pokemon> myFavoritesPokemons = [];
    emit(const FavoritesLoadingState());
    final List<String> myFavorites = hivePreferences.getAllFavoriteIds();

    for(final favoriteId in myFavorites) {
      final result = await pokemonRepository.getPokemonsByName(favoriteId);
      result.when(ok: (data) {
        myFavoritesPokemons.add(data);
      }, err: (error) {
        emit(FavoritesErrorState(error: error));
      });
    }
    emit(FavoritesLoadedState(pokemons: myFavoritesPokemons));
  }
}
