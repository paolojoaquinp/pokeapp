import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:oxidized/oxidized.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/bloc/home_bloc.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon_response/pokemon_response.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_helpers.dart';

final mockPokemonResponse = PokemonResponse(
    count: 2,
    next: 'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
    previous: '',
    results: [
      {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
      {'name': 'ivysaur', 'url': 'https://pokeapi.co/api/v2/pokemon/2/'},
    ],
  );

void main() {
  late HomeBloc homeBloc;
  late MockPokemonRepository mockPokemonRepository;
  late MockHiveHelper mockHiveHelper;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    mockHiveHelper = MockHiveHelper();
    homeBloc = HomeBloc(
      hiveHelper: mockHiveHelper,
      repository: mockPokemonRepository,
    );
  });

  tearDown(() {
    homeBloc.close();
  });


  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeDataLoadedState] when InitialEvent is added and data is fetched successfully',
      build: () {
        when(() => mockPokemonRepository.getPokemons())
            .thenAnswer((_) async => Ok(mockPokemonResponse));
        return homeBloc;
      },
      act: (bloc) => bloc.add(const InitialEvent()),
      expect: () => [
        HomeLoadingState(),
        HomeDataLoadedState(pokemonsResponse: mockPokemonResponse),
      ],
      verify: (_) {
        verify(() => mockPokemonRepository.getPokemons()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, ErrorState] when InitialEvent is added and fetching data fails',
      build: () {
        when(() => mockPokemonRepository.getPokemons())
            .thenAnswer((_) async => const Err('Error fetching Pokémon'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(const InitialEvent()),
      expect: () => [
        HomeLoadingState(),
        const ErrorState(error: 'Error fetching Pokémon'),
      ],
      verify: (_) {
        verify(() => mockPokemonRepository.getPokemons()).called(1);
      },
    );

    // Update method names based on your implementation
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, ErrorState] when RefreshEvent is added and refreshing data fails',
      build: () {
        when(() => mockPokemonRepository.fetchPokemon())
            .thenAnswer((_) async => const Err('Error refreshing Pokémon'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(const RefreshEvent()),
      expect: () => [
        HomeLoadingState(),
        const ErrorState(error: 'Error refreshing Pokémon'),
      ],
      verify: (_) {
        verify(() => mockPokemonRepository.fetchPokemon()).called(1);
      },
    );
  });
}
