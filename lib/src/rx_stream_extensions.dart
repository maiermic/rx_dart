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

  /// Merges this stream with all of the specified streams into one stream by
  /// using the selector function whenever any of the streams produces an
  /// element. If the result selector is omitted, a list with the elements will
  /// be yielded.
  RxStream<T> combineLatest(Iterable<Stream<T>> streams) =>
      Combinations.combineLatest(_streamWith(streams));

  /// Concatenates this stream with all of the specified streams, as long as
  /// the previous observable sequence terminated successfully.
  RxStream<T> concat(Iterable<Stream<T>> streams) =>
      Combinations.concat(_streamWith(streams));

  /// Projects each element of a stream to a stream and merges the resulting
  /// streams into one stream.
  RxStream concatMap(Stream selector(T value)) {
    StreamController controller;
    Future previousDone = new Future.value();
    onListen() async {
      stream.map(selector).listen(
          (Stream s) async {
            final previous = previousDone;
            final done = new Completer();
            previousDone = done.future;
            await previous;
            await controller.addStream(s);
            done.complete();
          },
          onDone: () async {
            await previousDone;
            controller.close();
          }
      );
    }
    controller = new StreamController(sync: true, onListen: onListen);
    return new RxStream(controller.stream);
  }

  /// Time shifts the stream by [duration].
  /// The relative time intervals between the values are preserved.
  RxStream<T> delay(Duration duration) =>
      asyncMap((event) => new Future.delayed(duration, () => event));

  /// Invokes an action for each element of the observable sequence.
  /// This method can be used for debugging, logging, etc. of query behavior by
  /// intercepting the message stream to run arbitrary actions for messages on
  /// the pipeline.
  RxStream<T> doOnNext(action(T event)) => map((event) {
    action(event);
    return event;
  });

  /// Projects each element of a stream to a stream and merges the resulting
  /// streams into one stream.
  RxStream flatMap(Stream selector(T value)) {
    StreamController controller;
    List<Future> onDones = [];
    onListen() async {
      stream.map(selector).listen(
        (Stream s) {
          var completer = new Completer();
          onDones.add(completer.future);
          s.listen(controller.add, onDone: completer.complete);
        },
        onDone: () async {
          await Future.wait(onDones);
          controller.close();
        }
      );
    }
    controller = new StreamController(sync: true, onListen: onListen);
    return new RxStream(controller.stream);
  }

  /// Merges this stream with all of the specified streams into a single stream.
  RxStream<T> merge(Iterable<Stream<T>> streams) =>
      Combinations.merge(_streamWith(streams));

  /// Applies an accumulator function over a stream and returns each
  /// intermediate result. The optional seed value is used as the initial
  /// accumulator value.
  RxStream scan(combine(acc, T element), [seed]) {
    var controller = new StreamController(sync: true);
    () async {
      stream = stream.asBroadcastStream();
      final isEmpty = stream.isEmpty;
      final init = (seed != null ? seed : controller);
      stream.fold(init, (acc, T element) {
        if (identical(acc, controller)) {
          controller.add(element);
          return element;
        }
        final combination = combine(acc, element);
        controller.add(combination);
        return combination;
      }).then((last) async {
        // add seed if stream is empty and seed is defined
        if (await isEmpty && seed != null) {
          controller.add(seed);
        }
        controller.close();
      });
    }();
    return new RxStream(controller.stream);
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

  /// Merges this stream with all the specified streams into one stream by
  /// using the selector function whenever all of the streams have produced
  /// an element at a corresponding index.
  RxStream zip(Iterable<Stream<T>> streams, Function resultSelector) =>
      Combinations.zip(_streamWith(streams), resultSelector);

  /// Merges this stream with all the specified streams into one stream by
  /// emitting a list with the elements of the stream at corresponding indexes
  /// whenever all of the streams have produced an element.
  RxStream<List<T>> zipArray(Iterable<Stream<T>> streams) =>
      Combinations.zipArray(_streamWith(streams));

  /// Prepends [stream] to [streams].
  Iterable<Stream<T>> _streamWith(Iterable<Stream<T>> streams) =>
      new List<Stream<T>>()
        ..add(stream)
        ..addAll(streams);
}