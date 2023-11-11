import 'package:hive/hive.dart';
import 'package:nostr/nostr.dart';
part 'account.g.dart';

@HiveType(typeId: 0)
class Account {
  late Keychain keychain;
  @HiveField(0)
  String keyId;
  @HiveField(1)
  List<String> contacts;
  @HiveField(2)
  List<String> blocked;
  @HiveField(3)
  List<String> relays;

  Account(
      {required this.keyId,
      required this.contacts,
      required this.blocked,
      required this.relays});
  get public {
    return keychain.public;
  }

  get private {
    return keychain.private;
  }

  get npub {
    return Nip19.encodePubkey(public);
  }

  get nsec {
    return Nip19.encodePrivkey(private);
  }
}
