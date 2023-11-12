import 'package:nostr/nostr.dart';

class NostrPost {
  final Event main;
  final List<Event> reactions;
  final List<Event> reposts;
  final List<Event> likes;

  NostrPost(
      {required this.main,
      required this.reactions,
      required this.reposts,
      required this.likes});
}
