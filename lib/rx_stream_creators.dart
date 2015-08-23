// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

/// Functions to create streams.
library rx_dart.creators;

import 'package:rx_dart/rx_dart.dart';

/// Returns a stream that contains a single element.
RxStream just(value) => new RxStream.fromIterable([value]);