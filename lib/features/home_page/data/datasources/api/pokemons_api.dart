import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';

class PokemonsApi {
  final _dio = Dio();

  Future<Result<PokemonResponse, String>> getPokemons() async {
    try {
      final response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final pokemonResponse = PokemonResponse.fromJson(json);
        return Ok(pokemonResponse);
      }
      return Err('Failed to fetch Pokémon: ${response.statusCode}');
    } catch (e) {
      return Err('An unexpected error occurred: $e');
    }
  }

  Future<Result<Pokemon, String>> getPokemonDetails(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final pokemonResponse = Pokemon.fromJson(json);
        return Ok(pokemonResponse);
      }
      return Err('Failed to fetch Pokémon: ${response.statusCode}');
    } catch (e) {
      return Err('An unexpected error occurred: $e');
    }
  }

  Future<Result<Pokemon, String>> getPokemonByName(String pokemonRequestName) async {
    try {
      final response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon/$pokemonRequestName',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final pokemonResponse = Pokemon.fromJson(json);
        return Ok(pokemonResponse);
      }
      return Err('Failed to fetch Pokémon: ${response.statusCode}');
    } catch (e) {
      return const Err('Pokemon not founded');
    }
  }

}
