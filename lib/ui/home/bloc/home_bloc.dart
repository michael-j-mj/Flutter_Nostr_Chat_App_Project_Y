import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_y_nostr/repo/repo.dart';
import 'package:nostr/nostr.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'home_event.dart';
part 'home_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Repo repo;
  bool isPost(List<List<String>> tags) {
    return tags.every((element) => element[0] != "e");
  }

  HomeBloc(this.repo) : super(HomeInitial()) {
    on<HomeEventLoad>((event, emit) async {
      List<Event> events = (await repo.getPosts(limit: 50))
          .where((element) => isPost(element.tags))
          .toList();
      await repo.getDetails(events: events);
      debugPrint("home bloc got ${events.length} posts");
      emit(HomeLoaded(events: List.from(events)));
    });
    on<HomeEventLoadMore>(
      _loadMore,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _loadMore(HomeEventLoadMore event, emit) async {
    if (state is HomeLoaded) {
      final state = this.state as HomeLoaded;
      List<Event> events = (await repo.getPosts(
              until: state.events[state.events.length - 1].createdAt - 1,
              limit: 50))
          .where((element) => isPost(element.tags))
          .toList();
      events.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              events: List.of(state.events)..addAll(events),
              hasReachedMax: false,
            ));
    }
  }
}
