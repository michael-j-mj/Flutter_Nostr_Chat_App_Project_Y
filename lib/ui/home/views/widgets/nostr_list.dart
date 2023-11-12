import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/ui/home/bloc/home_bloc.dart';
import 'package:flutter_y_nostr/ui/home/views/widgets/nostr_post_temp.dart';
import 'package:nostr/nostr.dart';

class NostrList extends StatefulWidget {
  final List<Event> events;
  const NostrList({super.key, required this.events});

  @override
  State<NostrList> createState() => _NostrListState();
}

class _NostrListState extends State<NostrList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<HomeBloc>().add(HomeEventLoadMore());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) {
      return const Center(child: Text('no posts'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeEventLoad());
      },
      child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.events.length + 1,
          itemBuilder: (context, index) => index >= widget.events.length
              ? Center(
                  child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ))
              : NostPostTemp(event: widget.events[index])),
    );
  }
}
