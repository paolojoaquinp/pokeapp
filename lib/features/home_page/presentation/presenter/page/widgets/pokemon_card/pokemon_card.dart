import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/pokemon_detail/presentation/pokemon_detail_page.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/widgets/pokemon_card/bloc/pokemon_card_bloc.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/widgets/pokemon_card/bloc/pokemon_card_state.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard(
      {super.key, required this.pokemonName, required this.urlDetail});

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonCardBloc>(
      create: (context) => PokemonCardBloc(urlDetail),
      child: _Body(pokemonName: pokemonName, urlDetail: urlDetail),
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
              color: Colors.black.withOpacity(0.2), // Color de la sombra
              spreadRadius: 2, // Expansión de la sombra
              blurRadius: 8, // Difuminado de la sombra
              offset: const Offset(0, 4), // Desplazamiento en x y en y
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
                  imageUrl: 'https://img.pokemondb.net/artwork/$pokemonName.jpg',
                  placeholder: (context, url) => const CircularProgressIndicator(), // Loader mientras descarga
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
                        BlocBuilder<PokemonCardBloc, PokemonCardState>(
                          builder: (context, state) {
                            return IconButton(
                              icon: Icon(
                                state.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: state.isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                context
                                    .read<PokemonCardBloc>()
                                    .toggleFavorite();
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
