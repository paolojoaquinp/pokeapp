import 'package:oxidized/oxidized.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonsApi api;
  final HiveHelper hiveHelper;

  PokemonRepositoryImpl({
    required this.api,
    required this.hiveHelper,
  });

  @override
  Future<Result<PokemonResponse, String>> getPokemons() async {
    try {
      if (hiveHelper.isCacheAvailable()) {
        final cachedData = hiveHelper.getCachedPokemons();
        final pokemonResponse = PokemonResponse.fromJson(cachedData);
        return Result.ok(pokemonResponse);
      } else {
        final apiResponse = await api.fetchPokemon();
        return apiResponse.when(
          ok: (data) async {
            await hiveHelper.cachePokemons(data.toJson());
            return Result.ok(data);
          },
          err: (err) {
            return Result.err(err);
          },
        );
      }
    } catch (error) {
      // Captura y retorna errores inesperados
      return Result.err(error.toString());
    }
  }

  @override
  Future<Result<Pokemon, String>> getPokemonDetails(String url) async {
    return api.getPokemonDetails(url);
  }

  @override
  Future<Result<PokemonResponse, String>> fetchPokemon() async {
    return api.fetchPokemon();
  }

  @override
  Future<Result<Pokemon, String>> getPokemonsByName(String pokemonRequestName) {
    return api.getPokemonByName(pokemonRequestName);
  }
}
