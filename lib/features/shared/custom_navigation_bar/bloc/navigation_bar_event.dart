part of 'navigation_bar_bloc.dart';

sealed class NavigationBarEvent extends Equatable {
  const NavigationBarEvent();

  @override
  List<Object> get props => [];
}

class NavigationBarPageChanged extends NavigationBarEvent {
  const NavigationBarPageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object> get props => [pageIndex];
}
