// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:test/test.dart';

void main() {
  group('concatMap', () {
    Stream<int> _selector(int x) => new RxStream.fromIterable([x, x + 1]);

    test('on empty stream completes empty', () {
      var stream = new RxStream.empty().concatMap(_selector);
      expect(stream.toList(), completion(equals([])));
    });

    test('emits flattened values of second after first selected stream', () {
      var stream = new RxStream<int>.fromIterable([0, 1]).concatMap((x) {
        StreamController<int> selected;
        addElements() {
          if (x == 0) {
            selected.add(0);
            new Future.delayed(new Duration(milliseconds: 100)).then((_) {
              selected.add(1);
              selected.close();
            });
          } else {
            selected.add(2);
            selected.close();
          }
        }
        selected = new StreamController<int>(sync: true, onListen: addElements);
        return selected.stream;
      });
      expect(stream.toList(), completion(equals([0, 1, 2])));
    });
  });
}