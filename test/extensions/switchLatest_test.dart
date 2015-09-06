// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.test;

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:rx_dart/rx_stream_creators.dart';
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
  });
}