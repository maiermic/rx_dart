// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.test;

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_combinations.dart';
import 'package:test/test.dart';


void main() {
  group('concat', () {
    test('two non broadcast streams', () {
      var s1 = new Stream<int>.fromIterable([0, 1]);
      var s2 = new Stream<int>.fromIterable([2, 3]);
      RxStream<int> stream = concat([s1, s2]);
      expect(stream.toList(), completion(equals([0, 1, 2, 3])));
    });
  });

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

  group('zipArray', () {
    test('two non broadcast streams one after another', () {
      var s1 = new Stream<int>.fromIterable([0, 1]);
      var s2 = new Stream<int>.fromIterable([2, 3, 4]);
      RxStream<int> stream = zipArray([s1, s2]);
      expect(stream.toList(), completion(equals([[0, 2], [1, 3]])));
    });
  });
}
