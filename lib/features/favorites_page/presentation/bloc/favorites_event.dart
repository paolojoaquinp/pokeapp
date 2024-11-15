part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class FavoritesInitialEvent extends FavoritesEvent {
  const FavoritesInitialEvent();

  @override
  List<Object> get props => [];
}
