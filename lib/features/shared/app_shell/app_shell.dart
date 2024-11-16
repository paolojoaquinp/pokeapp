// bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapp/core/constants/app_strings.dart';
import 'package:pokeapp/features/favorites_page/presentation/page/favorites_page.dart';
import 'package:pokeapp/features/home_page/presentation/presenter/page/home_page.dart';
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
              indicatorColor: Colors.white,
              selectedIndex: state.currentPageIndex,
              backgroundColor: Colors.white,
              onDestinationSelected: (index) => 
                context.read<AppShellBloc>().add(AppShellPageChangedEvent(index)),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home,color: Colors.red,),
                  label: AppStrings.home,
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite, color: Colors.red,),
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