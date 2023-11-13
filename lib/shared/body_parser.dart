import 'package:flutter/material.dart';

enum ParseTypes { text, image, video, website, nostr, at }

class NostrPostBodyParser extends StatefulWidget {
  final String rawBodyText;
  const NostrPostBodyParser({super.key, required this.rawBodyText});
  @override
  State<NostrPostBodyParser> createState() => _NostrPostBodyParserState();
}

class _NostrPostBodyParserState extends State<NostrPostBodyParser> {
  int maxSize = 14;
  final int mutliplier = 3;
  List<List<dynamic>> parsedData = [];
  List<Widget> content = [];

  @override
  void initState() {
    super.initState();
    parsedData = parseText(widget.rawBodyText);
  }

  @override
  void dispose() {
    super.dispose();
  }

  int calculateNumberOfLines(String text, double fontSize, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize),
      ),
      maxLines: null, // Allow unlimited lines
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    textPainter.layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length;
  }

  (List<Widget>, bool) fetchWidgets(double width) {
    int currentValue = 0;
    List<Widget> bodyWidgets = [];
    int fontSize = 12;
    bool newLineSpam = false;

    for (var data in parsedData) {
      Widget bodyWidget = Container();
      switch (data[0]) {
        case ParseTypes.text:
          int? maxLines;

          int lines =
              (calculateNumberOfLines(data[1], fontSize.toDouble(), width));

          if (data[1].isEmpty || data[1] == "\n" && bodyWidgets.isNotEmpty) {
            currentValue++;

            if (!(bodyWidgets.isNotEmpty &&
                bodyWidgets.last is Text &&
                currentValue < maxSize)) {
              bodyWidget = Text('');
              //   bodyWidgets.add(Text(''));
            }
            break;
          }
          if (lines > maxSize - currentValue + 2) {
            //+2 is added to give to ensure load more show signicant more
            maxLines = maxSize - currentValue + 1;
          }
          bodyWidget = SelectableText(
            data[1].trim(),
            maxLines: maxLines,
            scrollPhysics: NeverScrollableScrollPhysics(),
          );
          // bodyWidgets.add(SelectableText(
          //   data[1].trim(),
          //   maxLines: maxLines,
          //   scrollPhysics: NeverScrollableScrollPhysics(),
          // ));
          if (maxLines != null) {
            //this means the text widget would exceed max size
            return (bodyWidgets, false);
          }
          currentValue += lines;
          break;
        case ParseTypes.image:
          bodyWidget = Image.network(data[1]);
          //bodyWidgets.add(getImage(data[1]));
          currentValue += 7;
          break;
        case ParseTypes.video:
          bodyWidget = Text(data[1]);
          //bodyWidgets.add(CustomWebLauncher(url: data[1]));
          currentValue += 2;
          break;
        case ParseTypes.website:
          bodyWidget = Text(data[1]);
          //  bodyWidgets.add(CustomWebLauncher(url: data[1]));
          currentValue += 2;
          break;
        case ParseTypes.nostr:
          //todo for various nostr events
          if (data[1].startsWith("npub")) {
            bodyWidget = getProfileLink(data[1]);
            //bodyWidgets.add(getProfileLink(data[1]));
          } else {
            bodyWidget = Text(
              data[1].substring(12),
              style: TextStyle(fontWeight: FontWeight.bold),
            );
            // bodyWidgets.add(CustomNostrInternalLink(
            //   link: data[1],
            // ));
          }
          currentValue++;
          break;
        case ParseTypes.at:
          bodyWidget = getProfileLink(
              data[1]); //  bodyWidgets.add(getProfileLink(data[1]));
          currentValue++;
          break;
      }
      if (currentValue > maxSize) {
        return (bodyWidgets, false);
      } else {
        bodyWidgets.add(bodyWidget);
      }
    }

    return (bodyWidgets, true);
  }

  @override
  Widget build(BuildContext context) {
    //could change to record (int value, content) = parseURL....
    //this would allow to assign point to each type, ie: link worth 0.5, video =2 , image =1 etc,
    // therefor creating a smarter detector on max size
    bool loadedAll;
    List<Widget> bodyWidgets;

    (bodyWidgets, loadedAll) =
        fetchWidgets(MediaQuery.of(context).size.width * 0.7);

    if (!loadedAll) {
      bodyWidgets.add(Center(
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  maxSize *= mutliplier;
                });
              },
              child: const Text('Load More'))));
    } else {
      // bodyWidgets.add(Text(" \n"));
    }
    if (content!.length > maxSize) {
      content = content!.sublist(0, maxSize)
        ..add(Center(
            child: TextButton(
                onPressed: () {
                  setState(() {
                    maxSize *= mutliplier;
                  });
                },
                child: const Text('LOAD MORE'))));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: bodyWidgets,
    );
  }

  Widget getProfileLink(String pubkey) {
    return Text(
      pubkey.substring(12),
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  List<List<dynamic>> parseText(String rawText) {
    List<List<dynamic>> result = [];
    final regex = RegExp(
        r'(https?://\S+\.(jpg|jpeg|png|gif|mp4|avi|mov)|nostr:\S{40,}|\@npub\S{63}|\S+|\n)');
    final matches = regex.allMatches(rawText);
    String currentText = '';
    ParseTypes currentType = ParseTypes.text;
    for (var match in matches) {
      final matchText = match.group(0)!;

      if (matchText == '\n') {
        if (currentText.isNotEmpty) {
          result.add([currentType, currentText]);
          currentText = '';
        }
        // result.add([ParseTypes.text, ""]);
      } else if (matchText.startsWith('http') ||
          matchText.startsWith('https')) {
        if (currentText.isNotEmpty) {
          result.add([currentType, currentText]);
          currentText = '';
        }
        if (matchText.endsWith('.jpg') ||
            matchText.endsWith('.png') ||
            matchText.endsWith('.gif')) {
          result.add([ParseTypes.image, matchText]);
          currentType = ParseTypes.text;
        } else if (matchText.endsWith('.mp4') ||
            matchText.endsWith('.avi') ||
            matchText.endsWith('.mov')) {
          result.add([ParseTypes.video, matchText]);
          currentType = ParseTypes.text;
        } else {
          result.add([ParseTypes.website, matchText]);
          currentType = ParseTypes.text;
        }
      } else if (matchText.startsWith('nostr:')) {
        if (currentText.isNotEmpty) {
          result.add([currentType, currentText]);
          currentText = '';
        }
        result.add([ParseTypes.nostr, matchText.substring(6)]);
        currentType = ParseTypes.text;
      } else if (matchText.startsWith('@') && matchText.length >= 63) {
        if (currentText.isNotEmpty) {
          result.add([currentType, currentText]);
          currentText = '';
        }
        result.add([ParseTypes.at, matchText.substring(1)]);
        currentType = ParseTypes.text;
      } else {
        if (currentText.isNotEmpty) {
          currentText += ' ';
        }
        currentText += matchText;
      }
    }
    if (currentText.isNotEmpty) {
      result.add([currentType, currentText]);
    }
    return result;
  }
}
