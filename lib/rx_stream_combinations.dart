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

/// Merges all of the specified streams into one stream by using the selector
/// function whenever any of the streams produces an element. If the result
/// selector is omitted, a list with the elements will be yielded.
RxStream combineLatest(Iterable<Stream> streams) {
  var controller = new StreamController(sync: true);
  var latestValues = new Map<Stream, dynamic>();
  var pairs =
      streams.map((stream) => stream.map((event) => new _Pair(stream, event)));
  onListen(_Pair pair) {
    latestValues[pair.stream] = pair.event;
    if (latestValues.length == streams.length) {
      controller.add(new List.unmodifiable(latestValues.values));
    }
  }
  merge(pairs).listen(onListen, onDone: controller.close);
  return new RxStream(controller.stream);
}

class _Pair {
  final Stream stream;
  final event;
  _Pair(this.stream, this.event);
}

/// Merges the specified streams into one stream by emitting a list with the
/// elements of the stream at corresponding indexes whenever all of the
/// streams have produced an element.
RxStream<List> zipArray(Iterable<Stream> streams) {
  return new RxStream(new StreamZip(streams));
}

/// Merges the specified streams into one stream by using the selector function
/// whenever all of the streams have produced an element at a corresponding
/// index.
RxStream zip(Iterable<Stream> streams, Function resultSelector) {
  return zipArray(streams).map((args) => Function.apply(resultSelector, args));
}