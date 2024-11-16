import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/constants/app_strings.dart';
import 'package:pokeapp/features/favorites_page/presenter/bloc/favorites_bloc.dart';
import 'package:pokeapp/features/favorites_page/presenter/page/widgets/clear_all_button.dart';
import 'package:pokeapp/features/pokemon_detail/presenter/page/pokemon_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Page();
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          AppStrings.favorites,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FavoritesLoadedState) {
          return Column(
            children: [
              ClearFavoritesButton(
                onPressed: () {
                  context.read<FavoritesBloc>().clearAllFavorites();
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: state.pokemons.length,
                    itemBuilder: (_, index) {
                      final pokemon = state.pokemons[index];
                      final spriteUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id!}.png';
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: spriteUrl,
                          width: 40,
                          height: 40,
                          errorWidget: (_, ___, __) => const Icon(Icons.error),
                        ),
                        title: Text(pokemon.name!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PokemonDetailPage(
                                pokemonName: pokemon.name!,
                                urlDetail: 'https://pokeapi.co/api/v2/pokemon/${pokemon.id.toString()}',
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
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
    );
  }
}
