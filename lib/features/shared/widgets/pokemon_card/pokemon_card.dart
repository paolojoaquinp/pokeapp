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

    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.8, // Definimos una altura específica
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.amber[700]!,
          width: 8.0,
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with number and XP
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#25 $pokemonName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const Text(
                    '7 XP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Pokemon Image
            SizedBox(
              height:
                  constraints.maxHeight * 0.42, // 50% de la altura disponible
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.brown[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Hero(
                  tag: urlDetail,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://img.pokemondb.net/artwork/$pokemonName.jpg',
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),

            // Pokemon Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mouse',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '13.2 lbs.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Stage 1',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'When it is angered, it immediately discharges the energy stored in the pouches in its cheeks.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  BlocBuilder<FavoritesBloc, FavoritesState>(
                    buildWhen: (previous, current) {
                      if (previous is FavoritesLoadedState &&
                          current is FavoritesLoadedState) {
                        return previous.favoriteStatus[urlDetail] !=
                            current.favoriteStatus[urlDetail];
                      }
                      return true;
                    },
                    builder: (context, state) {
                      bool isFavorite = false;
                      if (state is FavoritesLoadedState) {
                        isFavorite = state.favoriteStatus[urlDetail] ?? false;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              context
                                  .read<FavoritesBloc>()
                                  .add(ToggleFavoriteEvent(id: urlDetail));
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
