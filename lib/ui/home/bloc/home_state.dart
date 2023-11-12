part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.events, this.hasReachedMax = false});

  final List<Event> events;
  final bool hasReachedMax;
  @override
  List<Object> get props => [events.length, hasReachedMax];
  HomeLoaded copyWith({List<Event>? events, bool? hasReachedMax}) {
    return HomeLoaded(
        events: events ?? this.events,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}
