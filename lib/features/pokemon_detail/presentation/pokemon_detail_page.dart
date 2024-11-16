import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/core/utils/utils.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/pokemon_detail/presentation/bloc/pokemon_details_bloc.dart';

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
          hiveHelper: HiveHelper(),
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
                // Pokemon Image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Hero(
                    tag: urlDetail,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  36.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://img.pokemondb.net/artwork/$pokemonName.jpg',
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                          _StatsGrid(pokemon: state.pokemon),
                          const SizedBox(height: 24),
                          _WhereToFind(pokemon: state.pokemon),
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

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.pokemon});

  final Pokemon pokemon;

  String _getStatValue(List<Stat>? stats, int index, String statName) {
    if (stats == null || stats.isEmpty) return '???';

    // Buscamos el stat por nombre en lugar de por índice
    final stat = stats.firstWhere(
      (stat) => stat.stat?.name == statName,
      orElse: () => Stat(base_stat: null, effort: 0, stat: null),
    );

    return stat.base_stat?.toString() ?? '???';
  }

  String _getStatName(Stat? stat) {
    if (stat?.stat?.name == null) return '???';
    return stat!.stat!.name!
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    print(pokemon.stats!);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.8,
      children: [
        _StatCard(
          icon: Icons.flash_on,
          value: pokemon.stats![1].base_stat!.toString(),
          label: pokemon.stats![1].stat!.name!.capitalize(),
          color: Colors.yellow,
          missingMessage: 'No Data',
        ),
        _StatCard(
          icon: Icons.shield,
          value: pokemon.stats![2].base_stat!.toString(),
          label: pokemon.stats![2].stat!.name!.capitalize(),
          color: Colors.blue,
          missingMessage: 'No Data',
        ),
        _StatCard(
          icon: Icons.favorite,
          value: pokemon.stats![0].base_stat!.toString(),
          label: pokemon.stats![0].stat!.name!.capitalize(),
          missingMessage: 'No Data',
          color: Colors.red,
        ),
        _StatCard(
          icon: Icons.speed,
          value: pokemon.stats!.last.base_stat!.toString(),
          label: pokemon.stats!.last.stat!.name!.capitalize(),
          color: Colors.purple,
          missingMessage: 'No Data',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.missingMessage,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final String missingMessage;

  @override
  Widget build(BuildContext context) {
    final bool isValueMissing = value == '???' || value == '??%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isValueMissing ? Colors.grey.shade300 : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isValueMissing ? Colors.grey.shade400 : color,
            size: 20,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isValueMissing ? '?' : value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isValueMissing ? Colors.grey.shade400 : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isValueMissing ? missingMessage : label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhereToFind extends StatelessWidget {
  const _WhereToFind({required this.pokemon});

  final Pokemon pokemon;

  String _getPokemonLocationInfo() {
    return 'You can get ${pokemon.name} Pokémon from 2 km eggs, and '
        'there is also a chance to catch it. You can catch ${pokemon.name} '
        'at the very beginning of the game, while you first 3 Pokémon are on the map.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where to catch?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _getPokemonLocationInfo(),
          style: const TextStyle(
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
