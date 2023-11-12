import 'package:flutter/material.dart';
import 'package:flutter_y_nostr/repo/implementation/hive_storage_impl.dart';
import 'package:flutter_y_nostr/repo/implementation/nostr_service_impl.dart';
import 'package:flutter_y_nostr/repo/implementation/secure_storage_impl.dart';
import 'package:flutter_y_nostr/repo/repo.dart';
import 'package:flutter_y_nostr/ui/app.dart';
import 'package:hive/hive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HiveStorageService local = HiveStorageService();
  SecureStorageService secure = SecureStorageService();
  NostrServiceImpl nostr = NostrServiceImpl();
  Repo repo = Repo(nostr: nostr, local: local, secure: secure);
  runApp(MyApp(repo));
}
