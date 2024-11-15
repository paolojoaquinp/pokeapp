import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/widgets/pokemon_card/bloc/pokemon_card_state.dart';

class PokemonCardBloc extends Cubit<PokemonCardState> {
  PokemonCardBloc(this.id) : super(PokemonCardState(id: id, isFavorite: false)) {
    _checkFavoriteStatus();
  }

  final String id;
  final HiveHelper _hiveHelper = HiveHelper();

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await _hiveHelper.isFavorite(id);
    emit(state.copyWith(isFavorite: isFavorite));
  }

  Future<void> toggleFavorite() async {
    if (state.isFavorite) {
      await _hiveHelper.removeFavorite(id);
    } else {
      await _hiveHelper.addFavorite(id);
    }
    _checkFavoriteStatus();
  }
}