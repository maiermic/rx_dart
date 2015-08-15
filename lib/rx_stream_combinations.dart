/// Functions to combine streams in certain ways.
library rx_dart.combinations;

import 'dart:async';

import 'package:rx_dart/rx_dart.dart';
import 'package:async/async.dart';

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

/// Merges all of the specified streams into a single stream.
RxStream merge(Iterable<Stream> streams) {
  return new RxStream(StreamGroup.merge(streams));
}

/// Merges the specified streams into one stream by emitting a list with the
/// elements of the stream at corresponding indexes whenever all of the
/// streams have produced an element.
RxStream zipArray(Iterable<Stream> streams) {
  return new RxStream(new StreamZip(streams));
}