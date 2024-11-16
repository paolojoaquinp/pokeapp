import 'package:flutter/material.dart';
import 'package:pokeapp/core/utils/utils.dart';
import 'package:pokeapp/features/home_page/domain/entities/pokemon/pokemon.dart';
import 'package:pokeapp/features/pokemon_detail/presenter/page/widgets/stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key, required this.pokemon});

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
        StatCard(
          icon: Icons.flash_on,
          value: pokemon.stats![1].base_stat!.toString(),
          label: pokemon.stats![1].stat!.name!.capitalize(),
          color: Colors.yellow,
          missingMessage: 'No Data',
        ),
        StatCard(
          icon: Icons.shield,
          value: pokemon.stats![2].base_stat!.toString(),
          label: pokemon.stats![2].stat!.name!.capitalize(),
          color: Colors.blue,
          missingMessage: 'No Data',
        ),
        StatCard(
          icon: Icons.favorite,
          value: pokemon.stats![0].base_stat!.toString(),
          label: pokemon.stats![0].stat!.name!.capitalize(),
          missingMessage: 'No Data',
          color: Colors.red,
        ),
        StatCard(
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
