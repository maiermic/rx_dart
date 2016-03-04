// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_creators.dart';
import 'package:stream_test_scheduler/stream_test_scheduler.dart';
import 'package:test/test.dart';
import 'dart:async';


void main() {
  group('takeUntil', () {
    test('on empty stream completes empty', () {
      var cancel = rx(new Future.delayed(ms(100)));
      var stream = new RxStream.empty().takeUntil(cancel);
      expect(stream.toList(), completion(equals([])));
    });

    test('all pass before cancel', () async {
      var scheduler = new TestScheduler();

      var source = scheduler.createStream([
        onNext(100, 1),
        onNext(200, 2),
        onNext(350, 3),
        onCompleted(350)
      ]);

      var cancel = scheduler.createStream([
        onNext(450, 'cancel'),
        onCompleted(450)
      ]);

      var result = await scheduler
          .startWithCreate(() => rx(source).takeUntil(cancel));

      expect(
          result,
          equalsRecords([
            onNext(100, 1),
            onNext(200, 2),
            onNext(350, 3),
            onCompleted(350)
          ], maxDeviation: 20)
      );
    });

    test('preempt some data next', () async {
      var scheduler = new TestScheduler();

      var source = scheduler.createStream([
        onNext(100, 1),
        onNext(200, 2),
        onNext(300, 3),
        onNext(400, 4),
        onNext(500, 5),
        onCompleted(500)
      ]);

      var cancel = scheduler.createStream([
        onNext(250, 'cancel'),
        onCompleted(250)
      ]);

      var result = await scheduler
          .startWithCreate(() => rx(source).takeUntil(cancel));

      expect(
          result,
          equalsRecords([
            onNext(100, 1),
            onNext(200, 2),
            onCompleted(250)
          ], maxDeviation: 20)
      );
    });
  });
}