// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_creators.dart';
import 'package:stream_test_scheduler/stream_test_scheduler.dart';
import 'package:test/test.dart';


void main() {
  group('flatMapLatest', () {
    test('on empty stream completes empty', () {
      final stream = new RxStream.empty().flatMapLatest((e) => e);
      expect(stream.toList(), completion(equals([])));
    });

    test('emits only elements of the latest stream', () async {
      final scheduler = new TestScheduler();

      final source = scheduler.createStream([
        onNext(30, 0),
        onNext(90, 1),
        onNext(100, 2),
        onCompleted(100)
      ]);

      final s0 = scheduler.createStream([
        onNext(30, 's0.1'),
        onNext(60, 's0.2'),
        onCompleted(60)
      ]);

      final s1 = scheduler.createStream([
        onNext(90, 's1.1'),
        onNext(120, 's1.2'),
        onCompleted(120)
      ]);

      final s2 = scheduler.createStream([
        onNext(100, 's2.1'),
        onNext(130, 's2.2'),
        onCompleted(130)
      ]);

      final result = await scheduler.startWithCreate(() =>
          rx(source).flatMapLatest([s0, s1, s2].elementAt));

      expect(
          result,
          equalsRecords([
            onNext(30, 's0.1'),
            onNext(60, 's0.2'),
            onNext(90, 's1.1'),
            onNext(100, 's2.1'),
            onNext(130, 's2.2'),
            onCompleted(130)
          ], maxDeviation: 20)
      );
    });
  });
}