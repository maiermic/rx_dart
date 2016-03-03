// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.test;

import 'package:test/test.dart';

import 'package:rx_dart/rx_dart.dart';


void main() {
  group('wrapped methods', () {
    test('toList completes with list', () {
      expect(new RxStream.fromIterable([1, 2, 3]).toList(), completion(equals([1, 2, 3])));
    });

    test('first completes with first element', () {
      expect(new RxStream.fromIterable([1, 2, 3]).first, completion(equals(1)));
    });
  });
}
