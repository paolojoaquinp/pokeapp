import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName ?? 'Pokemon Detail'),
      ),
      body: Expanded(
        child: Column(
          children: [
            Hero(
                tag: urlDetail,
                child: Image.network(
                  'https://img.pokemondb.net/artwork/$pokemonName.jpg' ?? 'https://picsum.photos/250?image=9',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              pokemonName ?? 'Unknown',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Agrega más detalles del Pokémon aquí.
          ],
        ),
      ),
    );
  }
}
