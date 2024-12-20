import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/utils/utils.dart';
import 'package:pokeapp/features/favorites_page/presenter/bloc/favorites_bloc.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemonName,
    required this.urlDetail,
    required this.onPressedIcon,
    required this.onTap,
  });

  final String pokemonName;
  final String urlDetail;
  final VoidCallback onPressedIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    context.read<FavoritesBloc>().add(CheckFavoriteStatusEvent(id: urlDetail));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.amber[100],
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.amber[700]!,
            width: 8.0,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Encabezado con nombre y XP
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${Utils.extractPenultimateValue(urlDetail)} ${pokemonName.capitalize()}',
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
              Container(
                height: 150.0,
                width: double.maxFinite,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.3), // Color de la sombra con opacidad
                      blurRadius: 10, // Difusión de la sombra
                      offset: const Offset(4, 4), // Posición de la sombra (x, y)
                    ),
                  ],
                ),
                child: Hero(
                  tag: urlDetail,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://img.pokemondb.net/artwork/$pokemonName.jpg',
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),

              // Descripción e íconos
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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

                    // Botón de favoritos
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
                        return Center(
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: onPressedIcon,
                          ),
                        );
                      },
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
