import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/bloc/home_bloc.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/widgets/pokemon_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) =>
          HomeBloc(repository: PokemonRepositoryImpl(PokemonsApi()))
            ..add(const InitialEvent()),
      child: _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    super.key,
  });

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
        appBar: AppBar(title: Text('Pokeapp'),),
        body: _Body(),
      )
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
  });

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
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0),
            itemCount: state.pokemonsResponse.results?.length ?? 0,
            itemBuilder: (context, index) {
              final pokemon = state.pokemonsResponse.results![index];
              return PokemonCard(pokemonName: pokemon['name'], urlDetail: pokemon['url'],);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
