import 'package:flutter/material.dart';
import 'package:pokeapp/features/home_page/presentation/children/pokemon_detail/presentation/pokemon_detail_page.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard(
      {super.key, required this.pokemonName, required this.urlDetail});

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
              offset: Offset(0, 4), // Desplazamiento en x y en y
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(9.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: urlDetail,
                child: Image.network(
                  'https://img.pokemondb.net/artwork/$pokemonName.jpg',
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
                    SizedBox(height: 16.0),
                    Text(
                      'Saber mas',
                      style: TextStyle(color: Colors.blueAccent),
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
