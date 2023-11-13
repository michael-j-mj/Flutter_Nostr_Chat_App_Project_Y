import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/models/nostr_metadata_model.dart';
import 'package:flutter_y_nostr/repo/repo.dart';
import 'package:flutter_y_nostr/shared/body_parser.dart';
import 'package:flutter_y_nostr/utils/util.dart';
import 'package:nostr/nostr.dart';

class NostPostTemp extends StatelessWidget {
  final Event event;
  const NostPostTemp({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    Repo repo = RepositoryProvider.of<Repo>(context);
    String imageUrl = Util.getRoboHashPicture(event.pubkey);
    NostrMetadata? metadata = repo.metaCache[event.pubkey];
    if (metadata != null) {
      if (metadata.picture != null) {
        imageUrl = metadata.picture;
      }
    }
    String displayName = metadata != null
        ? "${metadata.displayName} @ ${metadata.name}"
        : Util.keyEncode(event.pubkey).substring(0, 9);
    return Card(
      elevation: 4, // Add elevation
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add margin
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1), // Add black border
        borderRadius: BorderRadius.circular(8), // Optional: Add border radius
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  displayName,
                  overflow: TextOverflow.ellipsis,
                )),
                Expanded(
                    child: Text(
                  Util.getTimeAgo(event.createdAt),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            NostrPostBodyParser(rawBodyText: event.content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Text(
                        "💬${(repo.repliesCache[event.id] ?? []).length}")),
                IconButton(
                    onPressed: () {},
                    icon:
                        Text("🔃${(repo.repostCache[event.id] ?? []).length}")),
                IconButton(
                    onPressed: () {},
                    icon: Text(
                        "${repo.reactionCache.containsKey(event.id) && repo.reactionCache[event.id]!.isNotEmpty ? repo.reactionCache[event.id]!.first.content : "👍"} ${(repo.reactionCache[event.id] ?? []).length}"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
