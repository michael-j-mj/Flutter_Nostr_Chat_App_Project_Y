import 'package:nostr/nostr.dart';

class Util {
  static String keyDecode(String encoded) {
    if (encoded.startsWith("nsec")) {
      return Nip19.decodePrivkey(encoded);
    }
    if (encoded.startsWith("npub")) {
      return Nip19.decodePubkey(encoded);
    }
    throw FormatException("Invalid key prefix: $encoded");
  }

  static String keyEncode(String encoded, [bool isNsec = false]) {
    if (isNsec) {
      return Nip19.encodePrivkey(encoded);
    } else {
      return Nip19.encodePubkey(encoded);
    }
  }

  static String getRoboHashPicture(String pubkey) {
    String npub;
    if (!pubkey.startsWith("npub")) {
      npub = pubkey;
    } else {
      npub = keyEncode(pubkey);
    }
    return 'https://robohash.org/$npub.png';
  }

  static String getTimeAgo(int seconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}
