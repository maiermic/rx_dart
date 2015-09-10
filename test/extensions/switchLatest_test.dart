// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.test;

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_creators.dart';
import 'package:stream_test_scheduler/stream_test_scheduler.dart';
import 'package:test/test.dart';


void main() {
  group('switchLatest', () {
    test('on empty stream completes empty', () {
      var stream = new RxStream.empty().switchLatest();
      expect(stream.toList(), completion(equals([])));
    });

    test('on stream of a single stream emits elements of single stream', () {
      var stream = just(new RxStream.fromIterable([1, 2, 3])).switchLatest();
      expect(stream.toList(), completion(equals([1, 2, 3])));
    });

    test('on stream of streams emitting elements after previous streams have been completed', () async {
      final scheduler = new TestScheduler();

      final source = scheduler.createStream([
        onNext(30, scheduler.createStream([
          onNext(60, 's1.1'),
          onNext(90, 's1.2'),
          onNext(120, 's1.3'),
          onCompleted(150)
        ])),
        onNext(180, scheduler.createStream([
          onNext(210, 's2.1'),
          onNext(240, 's2.2'),
          onCompleted(270)
        ])),
        onCompleted(190)
      ]);

      final result = await scheduler
          .startWithCreate(() => rx(source).switchLatest());

      expect(
          result,
          equalsRecords([
            onNext(60, 's1.1'),
            onNext(90, 's1.2'),
            onNext(120, 's1.3'),
            onNext(210, 's2.1'),
            onNext(240, 's2.2'),
            onCompleted(270)
          ], maxDeviation: 20));
    });

    test('on stream of intersecting streams only emits elements of last received stream', () async {
      final scheduler = new TestScheduler();

      final source = scheduler.createStream([
        onNext(50, scheduler.createStream([
          onNext(100, 's1.1'),
          onNext(150, 's1.2'),
          onNext(200, 's1.3'),
          onCompleted(210)
        ])),
        onNext(170, scheduler.createStream([
          onNext(180, 's2.1'),
          onNext(220, 's2.2'),
          onCompleted(250)
        ])),
        onCompleted(180)
      ]);

      final result = await scheduler
          .startWithCreate(() => rx(source).switchLatest());

      expect(
          result,
          equalsRecords([
            onNext(100, 's1.1'),
            onNext(150, 's1.2'),
            onNext(180, 's2.1'),
            onNext(220, 's2.2'),
            onCompleted(250)
          ], maxDeviation: 20));
    });
  });
}