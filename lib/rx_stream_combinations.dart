/// Functions to combine streams in certain ways.
library rx_dart.combinations;

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';

/// Concatenates all of the specified streams, as long as the previous
/// observable sequence terminated successfully.
RxStream concat(Iterable<Stream> streams) {
  StreamController controller;
  onListen() async {
    for (Stream stream in streams) {
      await controller.addStream(stream);
    }
    controller.close();
  }
  controller = new StreamController(sync: true, onListen: onListen);
  return new RxStream(controller.stream);
}