enum ContentType { text, mention, image, video, website }

class Content {
  final ContentType type;
  final String content;

  Content(this.type, this.content);
}

List<Content> categorizeText(String rawText) {
  List<Content> categorizedList = [];
  StringBuffer currentText = StringBuffer();

  for (int i = 0; i < rawText.length; i++) {
    if (rawText[i] == '@') {
      if (currentText.isNotEmpty) {
        categorizedList.add(Content(ContentType.text, currentText.toString()));
        currentText.clear();
      }
      // Find mention
      int endIndex = rawText.indexOf(RegExp(r'[\s\n]'), i);
      endIndex = endIndex == -1 ? rawText.length : endIndex;
      String mention = rawText.substring(i, endIndex);
      categorizedList.add(Content(ContentType.mention, mention));
      i = endIndex - 1; // Move the index to the end of the mention
    } else if (rawText[i] == 'h' && rawText.startsWith('http', i)) {
      if (currentText.isNotEmpty) {
        categorizedList.add(Content(ContentType.text, currentText.toString()));
        currentText.clear();
      }
      // Find URL
      int endIndex = rawText.indexOf(RegExp(r'[\s\n]'), i);
      endIndex = endIndex == -1 ? rawText.length : endIndex;
      String url = rawText.substring(i, endIndex);
      categorizedList.add(url.startsWith('www.')
          ? Content(ContentType.website, url)
          : (url.endsWith('.jpg') ||
                  url.endsWith('.jpeg') ||
                  url.endsWith('.png'))
              ? Content(ContentType.image, url)
              : (url.endsWith('.mp4') ||
                      url.endsWith('.mov') ||
                      url.endsWith('.avi'))
                  ? Content(ContentType.video, url)
                  : Content(ContentType.website, url));
      i = endIndex - 1; // Move the index to the end of the URL
    } else {
      currentText.write(rawText[i]);
    }
  }

  if (currentText.isNotEmpty) {
    categorizedList.add(Content(ContentType.text, currentText.toString()));
  }

  return categorizedList;
}
