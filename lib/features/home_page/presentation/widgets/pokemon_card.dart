import 'package:flutter/material.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/home_page/presentation/children/pokemon_detail/presentation/pokemon_detail_page.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemonName, required this.urlDetail});

  final String pokemonName;
  final String urlDetail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailPage(pokemonName: pokemonName, urlDetail: urlDetail),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(9.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: urlDetail,
                child: Image.network(
                  'https://img.pokemondb.net/artwork/$pokemonName.jpg' ?? 'https://picsum.photos/250?image=9',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemonName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Some quick example text to build on  the card',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {},
                      child: Text('Read more'),
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