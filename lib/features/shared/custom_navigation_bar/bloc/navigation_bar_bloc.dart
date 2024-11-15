import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_bar_event.dart';
part 'navigation_bar_state.dart';

class NavigationBloc extends Bloc<NavigationBarEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigationBarPageChanged>(_onPageChanged);
  }

  void _onPageChanged(
    NavigationBarPageChanged event,
    Emitter<NavigationState> emit,
  ) {
    emit(state.copyWith(currentPageIndex: event.pageIndex));
  }
}