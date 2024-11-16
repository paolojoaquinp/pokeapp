import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/favorites_page/presentation/bloc/favorites_bloc.dart';
import 'package:pokeapp/features/pokemon_detail/presentation/pokemon_detail_page.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemonName,
    required this.urlDetail,
  });

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    // Verificar el estado del favorito al construir el widget
    context.read<FavoritesBloc>().add(CheckFavoriteStatusEvent(id: urlDetail));

    return _Body(
      pokemonName: pokemonName,
      urlDetail: urlDetail,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.pokemonName,
    required this.urlDetail,
  });

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailPage(
              pokemonName: pokemonName,
              urlDetail: urlDetail,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(9.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: urlDetail,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://img.pokemondb.net/artwork/$pokemonName.jpg',
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemonName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saber mas',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        BlocBuilder<FavoritesBloc, FavoritesState>(
                          buildWhen: (previous, current) {
                            // Primero verificamos si ambos estados son FavoritesLoadedState
                            if (previous is FavoritesLoadedState &&
                                current is FavoritesLoadedState) {
                              return previous.favoriteStatus[urlDetail] !=
                                  current.favoriteStatus[urlDetail];
                            }
                            // Si alguno de los estados no es LoadedState, debemos reconstruir
                            return true;
                          },
                          builder: (context, state) {
                            bool isFavorite = false;
                            if (state is FavoritesLoadedState) {
                              isFavorite =
                                  state.favoriteStatus[urlDetail] ?? false;
                            }

                            return IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                context
                                    .read<FavoritesBloc>()
                                    .add(ToggleFavoriteEvent(id: urlDetail));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
