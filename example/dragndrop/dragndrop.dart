// Copyright (c) 2015, Michael Maier. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

// RxJS example: https://github.com/Reactive-Extensions/RxJS/blob/master/examples/dragndrop/dragndrop.js

library rx_dart.example;

import 'dart:html';

import 'package:rx_dart/rx_stream_creators.dart';

main() {
  var dragTarget = document.getElementById('dragTarget');
  // Get the three major events
  var mouseUp   = rx(dragTarget.onMouseUp);
  var mouseMove = rx(document.onMouseMove);
  var mouseDown = rx(dragTarget.onMouseDown);

  var mouseDrag = mouseDown.flatMap((md) {

    // calculate offsets when mouse down
    var startX = md.offsetX, startY = md.offsetY;

    // Calculate delta with mouseMove until mouseUp
    return mouseMove.map((mm) {
      mm.preventDefault();

      return {
        'left': mm.clientX - startX,
        'top': mm.clientY - startY
      };
    }).takeUntil(mouseUp);
  });

  // Update position
  mouseDrag.listen((pos) {
    dragTarget.style.top = '${pos['top']}px';
    dragTarget.style.left = '${pos['left']}px';
  });
}