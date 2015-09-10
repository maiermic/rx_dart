// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_combinations.dart';
import 'package:test/test.dart';

void main() {
  group('combineLatest', () {
    test('of two streams', () {
      var c1 = new StreamController<int>(sync: true);
      var c2 = new StreamController<int>(sync: true);
      RxStream<List<int>> stream = combineLatest([c1.stream, c2.stream]);
      expect(stream.toList(), completion(equals([[0, 3], [0, 4], [1, 4]])));

      c1.add(0);
      c2.add(3);
      c2.add(4);
      c2.close();
      c1.add(1);
      c1.close();
    });
  });
}
