import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/favorites_page/presentation/bloc/favorites_bloc.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/widgets/pokemon_card/pokemon_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesBloc>(
      create: (context) =>
          FavoritesBloc(pokemonRepository: PokemonRepositoryImpl(PokemonsApi()))
            ..add(const FavoritesInitialEvent()),
      child: const _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Favoritos"),
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FavoritesLoadedState) {
              return Expanded(
                child: ListView.builder(
                    itemCount: state.pokemons.length,
                    itemBuilder: (_, index) {
                      final pokemon = state.pokemons[index];
                      return PokemonCard(
                        pokemonName: pokemon.name!,
                        urlDetail: 'https://pokeapi.co/api/v2/pokemon/${pokemon.name!}',
                      );
                    }),
              );
            }
            if (state is FavoritesErrorState) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        )
      ],
    );
  }
}
