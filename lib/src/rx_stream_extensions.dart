// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

part of rx_dart;

/// Stream with methods of Reactive Extensions.
class RxStream<T> extends StreamWrapper<T, RxStream> with StreamWrapperType<T, RxStream<T>> {
  /// Creates a stream wrapper with extra methods.
  ///
  /// If [stream] is omitted, an empty stream is wrapped.
  RxStream([stream = const Stream.empty()]) : super(stream);

  /// Creates an empty broadcast stream.
  ///
  /// This is a stream which does nothing except sending a done event
  /// when it's listened to.
  RxStream.empty() : this();

  /// Creates a new single-subscription stream from the future.
  ///
  /// When the future completes, the stream will fire one event, either
  /// data or error, and then close with a done-event.
  RxStream.fromFuture(Future<T> future) : this(new Stream.fromFuture(future));

  /// Creates a single-subscription stream that gets its data from [data].
  ///
  /// The iterable is iterated when the stream receives a listener, and stops
  /// iterating if the listener cancels the subscription.
  ///
  /// If iterating [data] throws an error, the stream ends immediately with
  /// that error. No done event will be sent (iteration is not complete), but no
  /// further data events will be generated either, since iteration cannot
  /// continue.
  RxStream.fromIterable(Iterable<T> data) : this(new Stream.fromIterable(data));

  /// Create a new stream wrapper instance that wraps [source].
  ///
  /// This method is needed by the super class [StreamWrapper] to be able to
  /// wrap stream return values of its methods as new [RxStream] instances.
  @override
  RxStream _newStreamWrapper(Stream source) {
    return new RxStream(source);
  }

  /// Prepend a sequence of values to this stream.
  RxStream<T> startWith(Iterable<T> values) {
    StreamController<T> controller;
    onListen() async {
      for (T value in values) {
        controller.add(value);
      }
      await controller.addStream(stream);
      controller.close();
    }
    controller = new StreamController<T>(sync: true, onListen: onListen);
    return new RxStream<T>(controller.stream);
  }
}