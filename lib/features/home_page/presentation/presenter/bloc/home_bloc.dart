import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InitialEvent>(_onInitialEvent);
  }

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
}
