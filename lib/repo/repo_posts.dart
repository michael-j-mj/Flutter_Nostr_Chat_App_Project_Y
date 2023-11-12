part of 'repo.dart';

extension NostrRepositoryAccount on Repo {
  ///until (Must be older then this value to pass)
  Future<List<Event>> getPosts({int? until, int limit = 33}) async {
    Filter filter = Filter(kinds: [1], until: until, limit: limit);
    List<Event> events =
        await nostr.getData([filter], relays: _account!.first.relays);

    return events;
  }

  Future<List<Event>> getDetails({required List<Event> events}) async {
    Set<String> authors = {};
    Set<String> ids = {};
    events.forEach((event) {
      if (!metaCache.containsKey(event.pubkey)) {
        authors.add(event.pubkey);
      }
      ids.add(event.id);
    });
    Filter metaFilter = Filter(kinds: [0], authors: authors.toList());
    Filter idFilter = Filter(kinds: [1, 6, 7], e: ids.toList());
    List<Event> details = await nostr
        .getData([metaFilter, idFilter], relays: _account!.first.relays);

    details.forEach((event) {
      switch (event.kind) {
        case 0:
          metaCache[event.pubkey] = NostrMetadata.fromEvent(event: event);
          break;
        case 1:
          String key = findFirstETag(event.tags);
          repliesCache[key] ??=
              <Event>[]; // If the key doesn't exist, initialize with an empty list
          repliesCache[key]!.add(event);
          break;
        case 6:
          String key = findFirstETag(event.tags);
          repostCache[key] ??=
              <Event>[]; // If the key doesn't exist, initialize with an empty list
          repostCache[key]!.add(event);
          break;
        case 7:
          String key = findFirstETag(event.tags);
          debugPrint("repo detail count ${key}");
          reactionCache[key] ??=
              <Event>[]; // If the key doesn't exist, initialize with an empty list
          reactionCache[key]!.add(event);
          break;
      }
    });
    return [];
  }

  String findFirstETag(List<List<String>> tags) {
    return tags.firstWhere((element) => element[0] == "e")[1];
  }
}
