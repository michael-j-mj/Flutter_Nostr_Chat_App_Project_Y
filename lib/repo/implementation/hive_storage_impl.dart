import 'package:flutter/material.dart';
import 'package:flutter_y_nostr/models/account.dart';
import 'package:flutter_y_nostr/models/nostr_metadata_model.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_local_storage_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService implements ILocalStorage {
  final String boxName;
  var box;
  HiveStorageService({this.boxName = 'HiveBox'});

  @override
  Future<void> start() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(NostrMetadataAdapter())
      ..registerAdapter(AccountAdapter());
    box = await Hive.openBox<List>(boxName);
  }

  @override
  Future<dynamic> read(LOCALSTORAGETYPE type) async {
    if (type == LOCALSTORAGETYPE.account) {
      try {
        List<Account>? nostrAcocunts = (box.get("account"))?.cast<Account>();
        return nostrAcocunts;
      } catch (e) {
        return null;
      }
    }
    if (type == LOCALSTORAGETYPE.metadata) {
      try {
        List<NostrMetadata>? nostrAcocunts =
            (box.get("metadata"))?.cast<NostrMetadata>();
        return nostrAcocunts;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<bool> update(LOCALSTORAGETYPE type, dynamic value) async {
    switch (type) {
      case LOCALSTORAGETYPE.account:
        List<Account> accounts = value.cast<Account>();

        debugPrint('ACCOUNT SAVED ${accounts.length}');
        await box.put('account', (accounts));
        break;
      case LOCALSTORAGETYPE.metadata:
        List<NostrMetadata> metaList = value.cast<NostrMetadata>();
        await box.put('metadata', metaList);
        break;
      case LOCALSTORAGETYPE.blockedList:
        break;
      case LOCALSTORAGETYPE.privateMessages:
        break;
      case LOCALSTORAGETYPE.relayList:
        break;
      case LOCALSTORAGETYPE.following:
        break;
    }

    return true;
  }

  @override
  Future<bool> delete(LOCALSTORAGETYPE type) async {
    box.delete(boxName);
    return true;
  }

  @override
  Future<bool> deleteAll() async {
    debugPrint('clearing all ');
    await box.clear();
    return true;
  }
}
