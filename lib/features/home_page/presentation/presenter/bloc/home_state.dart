part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class NavigationState extends Equatable {
  const NavigationState({this.selectedIndex = 0});

  final int selectedIndex;

  @override
  List<Object?> get props => [selectedIndex];
}