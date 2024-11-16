import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required this.pokemonRepository}) 
      : hivePreferences = HiveHelper(), 
        super(FavoritesInitial()) {
    on<FavoritesInitialEvent>(_onFavoritesInitialEvent);
    on<ToggleFavoriteEvent>(_onToggleFavoriteEvent);
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatusEvent);
  }

  final HiveHelper hivePreferences;
  final PokemonRepository pokemonRepository;

  Future<void> _onFavoritesInitialEvent(
    FavoritesInitialEvent event, 
    Emitter<FavoritesState> emit
  ) async {
    List<Pokemon> myFavoritesPokemons = [];
    emit(const FavoritesLoadingState());
    
    final List<String> myFavorites = hivePreferences.getAllFavoriteIds();
    Map<String, bool> favoriteStatus = {};

    for(final favoriteId in myFavorites) {
      final result = await pokemonRepository.getPokemonDetails(favoriteId);
      result.when(
        ok: (data) {
          myFavoritesPokemons.add(data);
          favoriteStatus[favoriteId] = true;
        }, 
        err: (error) {
          emit(FavoritesErrorState(error: error));
          return;
        }
      );
    }

    emit(FavoritesLoadedState(
      pokemons: myFavoritesPokemons,
      favoriteStatus: favoriteStatus,
    ));
  }

  Future<void> _onToggleFavoriteEvent(
    ToggleFavoriteEvent event, 
    Emitter<FavoritesState> emit
  ) async {
    if (state is FavoritesLoadedState) {
      final currentState = state as FavoritesLoadedState;
      final isFavorite = currentState.favoriteStatus[event.id] ?? false;

      if (isFavorite) {
        await hivePreferences.removeFavorite(event.id);
      } else {
        await hivePreferences.addFavorite(event.id);
      }

      // Actualizar el estado después de modificar favoritos
      final result = await pokemonRepository.getPokemonDetails(event.id);
      result.when(
        ok: (pokemon) {
          List<Pokemon> updatedPokemons = List.from(currentState.pokemons);
          Map<String, bool> updatedStatus = Map.from(currentState.favoriteStatus);
          
          if (!isFavorite) {
            if (!updatedPokemons.contains(pokemon)) {
              updatedPokemons.add(pokemon);
            }
          } else {
            updatedPokemons.removeWhere((p) => p.id == event.id);
          }
          
          updatedStatus[event.id] = !isFavorite;
          
          emit(FavoritesLoadedState(
            pokemons: updatedPokemons,
            favoriteStatus: updatedStatus,
          ));
        },
        err: (error) {
          emit(FavoritesErrorState(error: error));
        }
      );
    }
  }

  Future<void> _onCheckFavoriteStatusEvent(
    CheckFavoriteStatusEvent event, 
    Emitter<FavoritesState> emit
  ) async {
    if (state is FavoritesLoadedState) {
      final currentState = state as FavoritesLoadedState;
      final isFavorite = await hivePreferences.isFavorite(event.id);
      
      Map<String, bool> updatedStatus = Map.from(currentState.favoriteStatus);
      updatedStatus[event.id] = isFavorite;
      
      emit(currentState.copyWith(favoriteStatus: updatedStatus));
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await hivePreferences.clearAllFavorites();
      add(FavoritesInitialEvent());
    } catch (e) {
      throw(Exception(e));
    }
  }
}