import 'package:oxidized/oxidized.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonsApi _api;

  PokemonRepositoryImpl(this._api);

  @override
  Future<Result<PokemonResponse, String>> getPokemons() async {
    return _api.getPokemons();
  }

  @override
  Future<Result<Pokemon, String>> getPokemonDetails(String url) async {
    return _api.getPokemonDetails(url);
  }
}