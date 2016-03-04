// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

// RxJS example: https://github.com/Reactive-Extensions/RxJS/blob/master/examples/autocomplete/autocomplete.js

library rx_dart.example;

import 'dart:html';

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_creators.dart';
import 'package:jsonp/jsonp.dart' as jsonp;

RxStream searchWikipedia(String term) {
  return rx(jsonp.fetch(uri: 'https://en.wikipedia.org/w/api.php?action=opensearch&search=$term&format=json&callback=?'));
}

Element empty(Element results) {
  results.innerHtml = '';
  return results;
}

main() {
  var input = document.querySelector('#textInput');
  var results = document.querySelector('#results');

  // Get all distinct key up events from the input and only fire if long enough and distinct
  var keyup = rx(input.onKeyUp)
      .map((e) => e.target.value) // Project the text from the input
      .where((text) => text.length > 2) // Only if the text is longer than 2 characters
      .debounce(new Duration(milliseconds: 750) /* Pause for 750ms */ )
      .distinct(); // Only if the value has changed

  var searcher = keyup.flatMapLatest(searchWikipedia);

  searcher.listen(
      (data) {
          empty(results);
          List<String> searchResults = data[1];
          searchResults
              .map((v) => new Element.li()..appendText(v))
              .forEach((Element r) => results.append(r));
      },
      onError: (error) {
        empty(results)
            .append(new Element.li())
            .text = 'Error: $error';
      }
  );
}