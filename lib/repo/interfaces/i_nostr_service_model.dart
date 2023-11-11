import 'package:nostr/nostr.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract interface class INostrService {
  Future<List<Event>> getData(List<Filter> filter,
      {required List<String> relays});

  Future<List<Event>> getDataFromRelay(List<Filter> filter,
      {required String relay});

  WebSocketChannel getDataStream(List<Filter> filter, {required String relay});

  Future<bool> sendData(Event event, {required String relay});
}
