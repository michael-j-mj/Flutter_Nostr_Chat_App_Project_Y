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
}
