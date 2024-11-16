import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/constants/app_strings.dart';
import 'package:pokeapp/core/helpers/hive_helper.dart';
import 'package:pokeapp/core/utils/utils.dart';
import 'package:pokeapp/features/home_page/data/datasources/api/pokemons_api.dart';
import 'package:pokeapp/features/home_page/data/repositories_impl/pokemon_repository_impl.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/bloc/home_bloc.dart';
import 'package:pokeapp/features/pokemon_detail/presenter/page/pokemon_detail_page.dart';
import 'package:pokeapp/features/search_page/presenter/bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        pokemonRepository: PokemonRepositoryImpl(
          api: PokemonsApi(),
          hiveHelper: HiveHelper(),
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
              content: Text(AppStrings.errorSearchText),
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
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.65,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppStrings.hintSearchText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.45))
                    ),
                    controller: searchBloc.controller,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      searchBloc.add(SearchTextChangedEvent(query: value));
                    },
                  ),
                ),
                const CloseButton(),
              ],
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitialState) {
                    return const Center(
                      child: Text(AppStrings.searchInit),
                    );
                  }
                  if (state is SearchLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is SearchSuggestionLoadedState) {
                    final pokemons = state.pokemons; // Asume que es una lista
                    return ListView.builder(
                      itemCount: pokemons.results!.length,
                      itemBuilder: (context, index) {
                        final pokemon = pokemons.results![index];
                        final pokemonId = Utils.extractPenultimateValue(pokemon['url']);
                        final spriteUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';
                        return ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: spriteUrl,
                            width: 40,
                            height: 40,
                            errorWidget: (_, ___, __) =>
                                const Icon(Icons.error),
                          ),
                          title: Text(pokemon['name']!),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PokemonDetailPage(
                                  pokemonName: pokemon['name'],
                                  urlDetail: pokemon['url'],
                                ),
                              ),
                            );
                          },
                        );
                      },
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
            ),
          ],
        ),
      ),
    );
  }
}
