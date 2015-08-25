// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.test;

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