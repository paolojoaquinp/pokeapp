// bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/constants/app_strings.dart';
import 'package:pokeapp/features/favorites_page/presentation/page/favorites_page.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/home_page.dart';
import 'package:pokeapp/features/search_page/presentation/page/search_page.dart';
import 'package:pokeapp/features/shared/app_shell/bloc/app_shell_bloc.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static final List<Widget> _pages = [
    const HomePage(),
    const FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppShellBloc(),
      child: BlocBuilder<AppShellBloc, AppShellState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentPageIndex,
              children: _pages,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: state.currentPageIndex,
              onDestinationSelected: (index) => 
                context.read<AppShellBloc>().add(AppShellPageChangedEvent(index)),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: AppStrings.home,
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: AppStrings.favorites,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}