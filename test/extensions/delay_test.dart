// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_creators.dart';
import 'package:stream_test_scheduler/stream_test_scheduler.dart';
import 'package:test/test.dart';


void main() {
  group('delay', () {
    test('on empty stream completes empty', () {
      var stream = new RxStream.empty().delay(new Duration(milliseconds: 30));
      expect(stream.toList(), completion(equals([])));
    });

    test('preserves relative time interval', () async {
      final scheduler = new TestScheduler();

      final source = scheduler.createStream([
        onNext(30, 1),
        onNext(60, 2),
        onNext(90, 3),
        onCompleted(100)
      ]);

      final result = await scheduler.startWithCreate(() => rx(source).delay(new Duration(milliseconds: 1000)));

      expect(
          result,
          equalsRecords([
            onNext(1030, 1),
            onNext(1060, 2),
            onNext(1090, 3),
            onCompleted(1100)
          ], maxDeviation: 20)
      );
    });
  });
}