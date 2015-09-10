// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:test/test.dart';


void main() {
  group('flatMap', () {
    Stream<int> _selector(int x) => new RxStream.fromIterable([x, x + 1]);

    test('on empty stream completes empty', () {
      var stream = new RxStream.empty().flatMap(_selector);
      expect(stream.toList(), completion(equals([])));
    });

    test('on stream emits flattened values', () {
      var stream = new RxStream.fromIterable([0, 2, 4]).flatMap(_selector);;
      expect(stream.toList(), completion(equals([0, 1, 2, 3, 4, 5])));
    });
  });
}