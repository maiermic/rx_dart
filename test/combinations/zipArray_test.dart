// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_combinations.dart';
import 'package:test/test.dart';

void main() {
  group('zipArray', () {
    test('two non broadcast streams one after another', () {
      var s1 = new Stream<int>.fromIterable([0, 1]);
      var s2 = new Stream<int>.fromIterable([2, 3, 4]);
      RxStream<List<int>> stream = zipArray([s1, s2]);
      expect(stream.toList(), completion(equals([[0, 2], [1, 3]])));
    });
  });
}
