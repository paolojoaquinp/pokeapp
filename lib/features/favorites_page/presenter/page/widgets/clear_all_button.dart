import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/favorites_page/presenter/bloc/favorites_bloc.dart';

class ClearFavoritesButton extends StatelessWidget {
  const ClearFavoritesButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return IconButton(
          icon: const Icon(Icons.delete_sweep),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Clear Favorites'),
                  content: const Text('Are you sure you want to remove all favorites?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      onPressed: onPressed,
                      child: const Text('Clear'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}