// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.example;

import 'package:rx_dart/rx_dart.dart';

main() async {
  var s = new RxStream<int>.fromIterable([1, 2, 3]);
  var r = s.startWith([0]);
  print(await r.toList()); // [0, 1, 2, 3]
}
