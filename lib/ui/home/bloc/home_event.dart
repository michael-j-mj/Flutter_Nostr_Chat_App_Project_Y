part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeEventLoad extends HomeEvent {}

class HomeEventLoadMore extends HomeEvent {}

class HomeEventSendPost extends HomeEvent {
  final String content;

  const HomeEventSendPost({required this.content});
}
