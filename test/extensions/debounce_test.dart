// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_creators.dart';
import 'package:stream_test_scheduler/stream_test_scheduler.dart';
import 'package:test/test.dart';


void main() {
  group('debounce', () {
    test('on empty stream completes empty', () {
      final stream = new RxStream.empty().debounce(ms(30));
      expect(stream.toList(), completion(equals([])));
    });

    test('emits only latest element in the time window', () async {
      final scheduler = new TestScheduler();

      final source = scheduler.createStream([
        onNext(30, 1),
        onNext(40, 2),
        onNext(50, 3),
        onCompleted(50)
      ]);

      final result = await scheduler
          .startWithCreate(() => rx(source).debounce(ms(30)));

      expect(
          result,
          equalsRecords([
            onNext(80, 3),
            onCompleted(80)
          ], maxDeviation: 20)
      );
    });
  });
}