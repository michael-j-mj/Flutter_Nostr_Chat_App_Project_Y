import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_y_nostr/repo/interfaces/i_nostr_service_model.dart';

import 'package:nostr/nostr.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NostrServiceImpl implements INostrService {
  @override
  Future<List<Event>> getData(List<Filter> filter,
      {required List<String> relays}) async {
    List<Event> eventList = [];

    for (String relay in relays) {
      List<Event> eventsFromRelay =
          await getDataFromRelay(filter, relay: relay);
      eventList.addAll(eventsFromRelay);
      if (eventList.isNotEmpty) {
        // debugPrint(eventList[0].content);
        return eventList;
      } else {
        debugPrint('no result on $relay \n ');
      }
    }
    return eventList;
  }

  @override
  Future<List<Event>> getDataFromRelay(List<Filter> filter,
      {required String relay}) async {
    final Completer<List<Event>> complete = Completer<List<Event>>();
    List<Event> eventList = [];
    try {
      WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(relay));
      channel.sink.add(Request(generate64RandomHexChars(), filter).serialize());
      debugPrint('nostr service getting data for relay: $relay');

      channel.stream.timeout(
        const Duration(seconds: 5),
        onTimeout: (sink) {
          debugPrint('fetch timeout for relay: $relay');
          channel.sink.close();
          complete.complete([]);
        },
      ).listen(
        (event) {
          try {
            Message msg = Message.deserialize(event);

            if (msg.type == "EVENT") {
              Event eventMsg = msg.message;

              // We need to make additional checks here if making queries
              // Quries only have one filter and contain the search param
              if (filter.length == 1 &&
                  ![null, ""].contains(filter[0].search)) {
                bool match = false;
                final String query = filter[0].search.toString();
                final content = eventMsg.content.toString().toLowerCase();
                List<String> params = [];

                // If query param has spaces we'll need to split it
                if (query.contains(" ")) {
                  params = query.split(" ");
                } else {
                  params = [query];
                }

                // Loops through query params
                for (var param in params) {
                  // We first check
                  if (content.contains(param)) {
                    match = true;
                    break;
                  }

                  // If haven't broken, we loop through tags of event
                  for (var tag in eventMsg.tags) {
                    if (tag.contains("t") && tag.contains(param)) {
                      match = true;
                      break;
                    }
                  }
                }
                if (match) {
                  eventList.add(eventMsg);
                }
                // Other events can be added
              } else {
                eventList.add(eventMsg);
              }
            } else if (msg.type == 'EOSE') {
              channel.sink.close();
              complete.complete(eventList);
              // If we get an error notice for the filter, we should terminate
              // so that we don't wait for the timeout
            } else if (msg.type == 'NOTICE' &&
                msg.message.toLowerCase().contains('error')) {
              debugPrint('Notice from $relay ${msg.message}');
              channel.sink.close();
              complete.complete(eventList);
            }
          } catch (e) {
            debugPrint('websocket error');
          }
        },
        onError: (e) {
          debugPrint(e.toString());
          channel.sink.close();
          complete.complete([]);
        },
        cancelOnError: true,
      );
      return complete.future;
    } catch (e) {
      return [];
    }
  }

  @override
  WebSocketChannel getDataStream(
    List<Filter> filter, {
    required String relay,
  }) {
    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(relay));
    channel.sink.add(Request(generate64RandomHexChars(), filter).serialize());
    return channel;
  }

  Future<bool> sendDataAllRelays(Event event,
      {required List<String> relays}) async {
    int boolSent = 0;
    int boolFailed = 0;

    await Future.wait(relays.map((relay) async {
      if (await sendData(event, relay: relay)) {
        boolSent++;
      } else {
        boolFailed--;
      }
    }));

    return boolSent > boolFailed;
  }

  @override
  Future<bool> sendData(Event event, {required String relay}) async {
    try {
      WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(relay));
      final Completer<bool> sendResult = Completer<bool>();

      channel.sink.add(event.serialize());

      channel.stream.timeout(
        const Duration(seconds: 2),
        onTimeout: (_) {
          debugPrint('stream timed out');
          sendResult.complete(false);
        },
      ).listen(
        (event) {
          debugPrint('send complete $event');
          sendResult.complete(true);
          channel.sink.close(); // Close the channel after receiving a response.
        },
        onError: (e) {
          debugPrint('send error in stream: $e');
          sendResult.complete(false);
        },
        cancelOnError: true,
      );

      // Return the future from the Completer.
      return sendResult.future;
    } catch (e) {
      debugPrint('send failed: $e');
      return false;
    }
  }
}
