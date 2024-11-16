part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable{
  const HomeEvent();
}

class InitialEvent extends HomeEvent {
  const InitialEvent();

  @override
  List<Object> get props => [];
}

class RefreshEvent extends HomeEvent {
  const RefreshEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}