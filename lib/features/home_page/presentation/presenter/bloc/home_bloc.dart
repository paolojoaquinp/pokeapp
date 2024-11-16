import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : hiveHelper = HiveHelper(), super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InitialEvent>(_onInitialEvent);
    on<RefreshEvent>(_onRefreshEvent);
  }
  final HiveHelper hiveHelper;
  final PokemonRepository repository;

  Future<void> _onInitialEvent(
    InitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await repository.getPokemons();
    emit(HomeLoadingState());
    result.when(
      ok: (data) {
        if (data.results!.isNotEmpty) {
          emit(HomeDataLoadedState(pokemonsResponse: data));
        }
      },
      err: (err) => {emit(ErrorState(error: err.toString()))},
    );
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    try {
      final apiResponse = await repository.fetchPokemon();
      apiResponse.when(
          ok: (data) async {
            await hiveHelper.cachePokemons(data.toJson());
            emit(HomeDataLoadedState(pokemonsResponse: data));
          },
          err: (error) {
            emit(ErrorState(error: error.toString()));
          },
      );
    } catch (error) {
      emit(ErrorState(error: error.toString()));
    }
  }
}
