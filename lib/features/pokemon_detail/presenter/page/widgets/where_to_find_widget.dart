import 'package:flutter/material.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';

class WhereToFind extends StatelessWidget {
  const WhereToFind({super.key, required this.pokemon});

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
