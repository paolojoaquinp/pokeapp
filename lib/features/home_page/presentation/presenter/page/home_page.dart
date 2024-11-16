import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/bloc/home_bloc.dart';
import 'package:pokeapp/features/shared/widgets/pokemon_card/pokemon_card.dart';

// HomePage Widget
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) =>
          HomeBloc(repository: PokemonRepositoryImpl(
            api: PokemonsApi(),
            hiveHelper: HiveHelper(),
          ))
            ..add(const InitialEvent()),
      child: const _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong, please come back later.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.red,
          title: const Text(
            'Pokeapp',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is HomeDataLoadedState) {
          return PageView.builder(
            controller: PageController(
              viewportFraction: 0.85,
            ),
            itemCount: state.pokemonsResponse.results?.length ?? 0,
            itemBuilder: (context, index) {
              final pokemon = state.pokemonsResponse.results![index];
              return Center( // Centrar la tarjeta
                child: PokemonCard(
                  pokemonName: pokemon['name'],
                  urlDetail: pokemon['url'],
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}