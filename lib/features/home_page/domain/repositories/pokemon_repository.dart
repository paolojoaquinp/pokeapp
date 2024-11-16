import 'package:oxidized/oxidized.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';

abstract class PokemonRepository {
  Future<Result<PokemonResponse, String>> getPokemons();
  Future<Result<PokemonResponse, String>> fetchPokemon();
  Future<Result<Pokemon, String>> getPokemonDetails(String url);
  Future<Result<Pokemon, String>> getPokemonsByName(String pokemonRequestName);
}