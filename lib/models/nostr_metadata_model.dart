import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:nostr/nostr.dart';

part 'nostr_metadata_model.g.dart';

@HiveType(typeId: 1)
class NostrMetadata extends Equatable {
  @HiveField(0)
  final String pubkey;
  @HiveField(1)
  final String displayName;
  @HiveField(2)
  final String website;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String about;
  @HiveField(5)
  final String picture;
  @HiveField(6)
  // final String nip05;
  // @HiveField(7)
  final String id;
  @HiveField(8)
  //in seconds
  final DateTime createAt;
  @HiveField(9)
  // final String? subId;
  // @HiveField(10)
  final String? bannerURL;
  const NostrMetadata(
      {required this.pubkey,
      required this.displayName,
      required this.website,
      required this.name,
      required this.about,
      required this.picture,
      // required this.nip05,
      required this.createAt,
      //   this.subId,
      required this.id,
      this.bannerURL});

  NostrMetadata.withJson({
    required this.pubkey,
    required Map<String, dynamic> json,
    required this.id,
    // required this.subId,
    required time,
  })  : createAt = DateTime.fromMillisecondsSinceEpoch(time * 1000),
        displayName = json['display_name'] ?? "",
        name = json['name'] ?? "",
        website = json['website'] ?? "",
        about = json['about'] ?? "",
        // picture = json['picture'] ?? GlobalVariables.fallBackAvatar,
        picture = json['picture'] ?? '',
        bannerURL = json['banner'] ?? "";

  NostrMetadata.fromEvent({
    required Event event,
  }) : this.withJson(
            pubkey: event.pubkey,
            json: jsonDecode(event.content),
            id: event.id,
            //  subId: event.subscriptionId,
            time: event.createdAt);

  String getJsonBody() {
    String body = jsonEncode({
      'display_name': displayName,
      'name': name,
      'website': website,
      'about': about,
      'picture': picture,
      //   'nip05': nip05,
      'banner': bannerURL
    });
    return body;
  }

  // (String, String) getCheckedNames() {
  //   return Util.getNames(pubkey,
  //       displayName: displayName, name: name);
  // }

  @override
  List<Object?> get props => [displayName, name, website, picture, bannerURL];
}
