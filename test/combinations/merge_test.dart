// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_combinations.dart';
import 'package:test/test.dart';

void main() {
  group('merge', () {
    test('two non broadcast streams', () {
      var s1 = new Stream<int>.fromIterable([0, 1, 2]);
      var s2 = new Stream<int>.fromIterable([3, 4, 5, 6, 7]);
      RxStream<int> stream = merge([s1, s2]);
      expect(stream.toList(), completion(equals([0, 3, 1, 4, 2, 5, 6, 7])));
    });

    test('two broadcast streams', () {
      var c1 = new StreamController<int>.broadcast(sync: true);
      var c2 = new StreamController<int>.broadcast(sync: true);
      RxStream<int> stream = merge([c1.stream, c2.stream]);
      expect(stream.toList(), completion(equals([0, 3, 1, 2, 4, 5])));

      c1.add(0);
      c2.add(3);
      c1.add(1);
      c1.add(2);
      c1.close();
      c2.add(4);
      c2.add(5);
      c2.close();
    });
  });
}
