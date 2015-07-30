// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

/// This library provides [Reactive Extensions](http://reactivex.io) for Dart Streams.
///
/// The goal of this library is to provide most of the common [Reactive Extensions](http://reactivex.io) methods
/// that the regular Dart [Stream] class is missing. For example
/// [startWith](http://reactivex.io/documentation/operators/startwith.html),
/// [concat](http://reactivex.io/documentation/operators/concat.html),
/// [merge](http://reactivex.io/documentation/operators/merge.html) and
/// [zip](http://reactivex.io/documentation/operators/zip.html).
///
/// Therefore, a regular Dart [Stream] is extended by a wrapper class that provides extra methods.
/// Since this wrapper implements the regular Dart [Stream] class,
/// it can be used like a regular Dart [Stream].
library rx_dart;

import 'dart:async';
import 'package:rx_dart/rx_stream_combinations.dart' as Combinations;

part 'src/rx_stream_wrapper.dart';
part 'src/rx_stream_type.dart';
part 'src/rx_stream_extensions.dart';
