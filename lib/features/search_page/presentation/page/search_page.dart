import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/bloc/home_bloc.dart';
import 'package:pokeapp/features/shared/widgets/pokemon_card/pokemon_card.dart';
import 'package:pokeapp/features/search_page/presentation/bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        pokemonRepository: PokemonRepositoryImpl(
          PokemonsApi(),
        ),
      )..add(const SearchInitialEvent()),
      child: _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong, please come back later.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeAPI'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchBloc.controller,
              decoration: const InputDecoration(
                hintText: 'Buscar Pokemon',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                searchBloc.add(SearchPokemonEvent(pokemonRequestName: value));
              },
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchInitialState) {
                return const Center(
                  child: Text('Start your search'),
                );
              }
              if (state is SearchLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SearchLoadedState) {
                final pokemon = state.pokemon;
                return PokemonCard(
                  pokemonName: pokemon.name!,
                  urlDetail:
                      'https://pokeapi.co/api/v2/pokemon/${pokemon.name!}',
                );
              }
              if (state is SearchErrorState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(state.error.toString()),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
