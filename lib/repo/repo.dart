import 'package:flutter/material.dart';
import 'package:flutter_y_nostr/models/account.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_local_storage_model.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_nostr_service_model.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_secure_storage_model.dart';
import 'package:nostr/nostr.dart';

class Repo {
  Repo({required this.nostr, required this.local, required this.secure});
  INostrService nostr;
  ILocalStorage local;
  ISecureStorage secure;
  Account? account;
  Future<bool> load() async {
    await local.start();
    account = await local.read(LOCALSTORAGETYPE.account);
    if (account == null) return false;
    String? privateKey = await secure.read(account!.keyId);
    if (privateKey == null) return false;
    try {
      Keychain keychain = Keychain(privateKey);
      account!.keychain = keychain;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
