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

class ToggleFavoriteEvent extends FavoritesEvent {
  const ToggleFavoriteEvent({
    required this.id,
  });

  final String id;

  @override
  List<Object> get props => [id];
}

class CheckFavoriteStatusEvent extends FavoritesEvent {
  const CheckFavoriteStatusEvent({required this.id});
  
  final String id;

  @override
  List<Object> get props => [id];
}

