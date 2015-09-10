// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'package:rx_dart/rx_dart.dart';
import 'package:test/test.dart';

void main() {
  group('scan', () {
    int _sum(int acc, int x) => acc + x;

    group('without seed', () {
      test('on empty stream completes empty', () {
        var stream = new RxStream.empty().scan(_sum);
        expect(stream.isEmpty, completion(isTrue));
      });

      test('on single element stream emits element', () {
        var stream = new RxStream.fromIterable([1]).scan(_sum);;
        expect(stream.toList(), completion(equals([1])));
      });

      test('on stream emits combined elements', () {
        var stream = new RxStream.fromIterable([1, 2, 4]).scan(_sum);;
        expect(stream.toList(), completion(equals([1, 3, 7])));
      });
    });

    group('with seed', () {
      test('on empty stream completes with seed', () {
        var stream = new RxStream.empty().scan(_sum, 4);
        expect(stream.toList(), completion(equals([4])));
      });

      test('on single element stream emits element', () {
        var stream = new RxStream.fromIterable([1]).scan(_sum, 4);;
        expect(stream.toList(), completion(equals([5])));
      });

      test('on stream emits combined elements', () {
        var stream = new RxStream.fromIterable([1, 2, 4]).scan(_sum, 4);;
        expect(stream.toList(), completion(equals([5, 7, 11])));
      });
    });
  });
}