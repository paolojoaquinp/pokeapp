import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/core/utils/utils.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/pokemon_detail/presenter/bloc/pokemon_details_bloc.dart';
import 'package:pokeapp/features/pokemon_detail/presenter/page/widgets/stats_grid_widget.dart';
import 'package:pokeapp/features/pokemon_detail/presenter/page/widgets/where_to_find_widget.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({
    super.key,
    required this.pokemonName,
    required this.urlDetail,
  });

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonDetailsBloc>(
      create: (context) => PokemonDetailsBloc(
        repository: PokemonRepositoryImpl(
          api: PokemonsApi(),
        ),
      )..add(PokemonDetailsInitialEvent(pokemonName: pokemonName)),
      child: _Page(
        pokemonName: pokemonName,
        urlDetail: urlDetail,
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    required this.pokemonName,
    required this.urlDetail,
  });

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Image.asset(
          'assets/images/pokeapp-icon.png',
          fit: BoxFit.cover,
          height: kToolbarHeight,
        ),
      ),
      body: _Body(urlDetail: urlDetail, pokemonName: pokemonName),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.urlDetail,
    required this.pokemonName,
  });

  final String urlDetail;
  final String pokemonName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailsBloc, PokemonDetailsState>(
      builder: (context, state) {
        if (state is DetailsLoadedState) {
          return Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Hero(
                    tag: urlDetail,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  26.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          color: Colors.white,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://img.pokemondb.net/artwork/$pokemonName.jpg',
                            height: 250,
                            fit: BoxFit.fitHeight,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // White Card Content
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.pokemon.name!.capitalize(),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          StatsGrid(pokemon: state.pokemon),
                          const SizedBox(height: 24),
                          WhereToFind(pokemon: state.pokemon),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
