part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable{
  const HomeEvent();
}


class TabChanged extends HomeEvent {
  final int index;

  const TabChanged(this.index);

  @override
  List<Object?> get props => [index];
}