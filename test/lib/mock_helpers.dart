import 'package:mocktail/mocktail.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';

class MockHiveHelper extends Mock implements HiveHelper {}

class MockPokemonApi extends Mock implements PokemonsApi {}


class MockPokemonRepository extends Mock implements PokemonRepository {}