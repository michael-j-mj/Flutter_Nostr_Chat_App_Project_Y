import 'package:flutter/material.dart';
import 'package:flutter_y_nostr/constants/global.dart';
import 'package:flutter_y_nostr/models/account.dart';
import 'package:flutter_y_nostr/models/nostr_metadata_model.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_local_storage_model.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_nostr_service_model.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_secure_storage_model.dart';
import 'package:nostr/nostr.dart';
part 'repo_posts.dart';

class Repo {
  Repo({required this.nostr, required this.local, required this.secure});
  INostrService nostr;
  ILocalStorage local;
  ISecureStorage secure;
  List<Account>? _account = [];
  Map<String, NostrMetadata> metaCache = {};
  Map<String, List<Event>> reactionCache = {};
  Map<String, List<Event>> repliesCache = {};
  Map<String, List<Event>> repostCache = {};
  Future<bool> load() async {
    _account = (await local.read(LOCALSTORAGETYPE.account));
    debugPrint("Found account " + _account.toString() ?? "EMPTY");
    if (_account == null || _account!.isEmpty) return false;
    String? privateKey = await secure.read(_account!.first.keyId);
    if (privateKey == null) return false;
    try {
      Keychain keychain = Keychain(privateKey);
      _account!.first.keychain = keychain;
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }

  Future<bool> createAccount(Keychain keychain) async {
    String keyId = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    Account account = Account(
        blocked: [],
        contacts: [],
        relays: Global.defaultRelays,
        keyId: keyId.toString());
    try {
      secure.write(keyId, keychain.private);
      local.update(LOCALSTORAGETYPE.account, [account]);
      _account = [account];
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> clearAccount() async {
    try {
      secure.delete(_account!.first.keyId);
      local.deleteAll();
      _account = [];
      return true;
    } catch (e) {
      return false;
    }
  }
}
