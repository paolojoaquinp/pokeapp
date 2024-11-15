import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/home_page/domain/repositories/pokemon_repository.dart';
import 'package:pokeapp/features/home_page/presentation/children/pokemon_detail/presentation/bloc/pokemon_details_bloc.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({
    Key? key,
    required this.pokemonName,
    required this.urlDetail,
  }) : super(key: key);

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonDetailsBloc>(
      create: (context) => PokemonDetailsBloc(
        repository: PokemonRepositoryImpl(
          PokemonsApi(),
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
    super.key,
    required this.pokemonName,
    required this.urlDetail,
  });

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName ?? 'Pokemon Detail'),
      ),
      body: _Body(urlDetail: urlDetail, pokemonName: pokemonName),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
    required this.urlDetail,
    required this.pokemonName,
  });

  final String urlDetail;
  final String pokemonName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Hero(
            tag: urlDetail,
            child: Image.network(
              'https://img.pokemondb.net/artwork/$pokemonName.jpg' ??
                  'https://picsum.photos/250?image=9',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pokemonName ?? 'Unknown',
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
                return Expanded(
                  child: Column(
                    children: [
                      Text(state.pokemon.abilities!.first.ability!.name ?? 'Sin Habilidad'),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator(),);
              }
            },
          )
        ],
      ),
    );
  }
}
