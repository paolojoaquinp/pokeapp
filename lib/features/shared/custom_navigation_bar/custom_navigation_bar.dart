// bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/features/favorites_page/presentation/page/favorites_page.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/home_page.dart';
import 'package:pokeapp/features/search_page/presentation/page/search_page.dart';
import 'package:pokeapp/features/shared/custom_navigation_bar/bloc/navigation_bar_bloc.dart';

class BottomNavigationComponent extends StatelessWidget {
  const BottomNavigationComponent({super.key});

  static final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentPageIndex,
              children: _pages,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: state.currentPageIndex,
              onDestinationSelected: (index) => 
                context.read<NavigationBloc>().add(NavigationBarPageChanged(index)),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search),
                  label: 'Buscar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}