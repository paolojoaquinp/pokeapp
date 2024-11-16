import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
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
      )..add(PokemonDetailsInitialEvent(urlDetailPokemon: urlDetail)),
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
      appBar: AppBar(
        title: Text(pokemonName),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Hero(
            tag: urlDetail,
            child: Image.network(
              'https://img.pokemondb.net/artwork/$pokemonName.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pokemonName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const Text(
            "Detalles:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          BlocBuilder<PokemonDetailsBloc, PokemonDetailsState>(
            builder: (context, state) {
              if (state is DetailsLoadedState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Habilidades:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...state.pokemon.abilities!.map((ability) => Text(
                          '${ability.ability!.name} ${ability.isHidden == true ? "(Oculta)" : ""}')),
                      const SizedBox(height: 8),
                      const Text("Estadísticas Base:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...state.pokemon.stats!.map((stat) =>
                          Text('${stat.stat!.name}: ${stat.baseStat}')),
                      const SizedBox(height: 8),
                      const Text("Movimientos:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...state.pokemon.moves!.take(5).map((move) => Text(
                          '${move.move!.name} - Nivel ${move.versionGroupDetails?.first.levelLearnedAt.toString()}')),
                      const SizedBox(height: 8),
                      const Text("Altura y Peso:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Altura: ${state.pokemon.height} dm'),
                      Text('Peso: ${state.pokemon.weight} hg'),
                      const SizedBox(height: 8),
                      const Text("Tipos:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...state.pokemon.types!
                          .map((type) => Text(type.type!.name!)),
                      const SizedBox(height: 8),
                      Text(
                          "Experiencia Base: ${state.pokemon.baseExperience}"),
                      const SizedBox(height: 8),
                      if (state.pokemon.sprites!.frontDefault != null)
                        Image.network(state.pokemon.sprites!.frontDefault!),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
