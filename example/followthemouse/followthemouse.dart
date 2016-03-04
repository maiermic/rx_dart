// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

// RxJS example: https://github.com/Reactive-Extensions/RxJS/blob/master/examples/dragndrop/dragndrop.js

library rx_dart.example;

import 'dart:html';

import 'package:rx_dart/rx_stream_creators.dart';
import 'dart:math';

Random _rng = new Random();

extractClientX(MouseEvent e) => e.client.x;
extractClientY(MouseEvent e) => e.client.y;
setLeft(Element e) => (double x) { e.style.left = '${x}px'; };
setTop(Element e) => (double y) { e.style.top = '${y}px'; };
add(x, y) => x + y;
partialAdd(x) => (y) => x + y;
randomize() => (_rng.nextInt(10) - 5).round();

main() {
  var delay = new Duration(milliseconds: 300);

  var mousemove = rx(document.onMouseMove);
  var left = mousemove.map(extractClientX);
  var top = mousemove.map(extractClientY);

  // Update the mouse
  var themouse = document.querySelector('#themouse');
  left.listen(setLeft(themouse));
  top.listen(setTop(themouse));

  // Update the tail
  var mouseoffset = themouse.offsetWidth;
  var thetail = document.querySelector('#thetail');
  left
      .map(partialAdd(mouseoffset))
      .delay(delay)
      .listen(setLeft(thetail));
  top
      .delay(delay)
      .listen(setTop(thetail));

  // Update wagging
  var wagDelay = delay * 1.5;
  var wagging = document.querySelector('#wagging');
  var mouseandtailoffset = mouseoffset + thetail.offsetWidth;
  left
      .map(partialAdd(mouseandtailoffset))
      .delay(wagDelay)
      .listen(setLeft(wagging));

  var waggingDelay = interval(100).map((_) => randomize());

  top.delay(wagDelay)
      .combineLatest([waggingDelay], add)
      .listen(setTop(wagging));
}