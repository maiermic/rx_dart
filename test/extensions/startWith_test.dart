// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:test/test.dart';


void main() {
  group('startWith', () {
    test('on empty stream emits start values', () {
      var stream = new RxStream.empty().startWith([0, 1]);
      expect(stream.toList(), completion(equals([0, 1])));
    });

    test('on stream emits start values followed by stream values', () {
      var stream = new RxStream.fromIterable([2, 3]).startWith([0, 1]);
      expect(stream.toList(), completion(equals([0, 1, 2, 3])));
    });

    test('forwards error of stream after start values', () {
      new RxStream.fromFuture(new Future.error('oh no'))
        .startWith([1])
        .listen(
          expectAsync((number){
            expect(number, equals(1));
          }, count: 1),
          onError: expectAsync((error) {
            expect(error, equals('oh no'));
          }, count: 1)
        );
    });
  });
}