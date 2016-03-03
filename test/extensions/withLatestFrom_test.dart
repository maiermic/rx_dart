// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'package:rx_dart/rx_stream_creators.dart';
import 'package:stream_test_scheduler/stream_test_scheduler.dart';
import 'package:test/test.dart';


void main() {
  group('withLatestFrom', () {
    int add(int a, int b) => a + b;

    test('only produces an element when the source observable sequence produces an element', () async {
      final scheduler = new TestScheduler();

      final e1 = scheduler.createStream([
        onNext(90, 1),
        onNext(180, 2),
        onCompleted(180)
      ]);

      final e2 = scheduler.createStream([
        onNext(30, 10),
        onNext(60, 20),
        onNext(120, 30),
        onNext(150, 40),
        onCompleted(150)
      ]);

      final result = await scheduler
          .startWithCreate(() => rx(e1).withLatestFrom([e2], add));

      expect(
          result,
          equalsRecords([
            onNext(90, 20 + 1),
            onNext(180, 40 + 2),
            onCompleted(180)
          ], maxDeviation: 20)
      );
    });
  });
}