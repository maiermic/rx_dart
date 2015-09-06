// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.test;

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:test/test.dart';


void main() {
  group('switchLatest', () {
    test('on empty stream completes empty', () {
      var stream = new RxStream.empty().switchLatest();
      expect(stream.toList(), completion(equals([])));
    });
  });
}