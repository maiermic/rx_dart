// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

/// Functions to create streams.
library rx_dart.creators;

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';

/// Creates an empty broadcast stream.
///
/// This is a stream which does nothing except sending a done event
/// when it's listened to.
RxStream empty() => new RxStream.empty();

/// Returns a stream that contains a single element.
RxStream just(value) => new RxStream.fromIterable([value]);

/// Converts stream to [RxStream].
RxStream rx(data) {
  if (data is Stream) return new RxStream(data);
  if (data is Future) return new RxStream.fromFuture(data);
  if (data is Iterable) return new RxStream.fromIterable(data);
  throw new ArgumentError.value(data);
}