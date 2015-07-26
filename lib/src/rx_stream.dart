// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

library rx_dart.stream;

import 'dart:async';


/// Wrapper of a [Stream].
class StreamWrapper<T> implements Stream<T> {
  /// Wrapped stream.
  Stream<T> stream;

  /// Creates a stream wrapper.
  ///
  /// If [stream] is omitted, an empty stream is wrapped.
  ///
  StreamWrapper([this.stream = const Stream.empty()]);

  /// Creates an empty broadcast stream.
  ///
  /// This is a stream which does nothing except sending a done event
  /// when it's listened to.
  ///
  StreamWrapper.empty() : this();

  /// Creates a new single-subscription stream from the future.
  ///
  /// When the future completes, the stream will fire one event, either
  /// data or error, and then close with a done-event.
  ///
  StreamWrapper.fromFuture(Future<T> future) : this(new Stream.fromFuture(future));

  /// Creates a single-subscription stream that gets its data from [data].
  ///
  /// The iterable is iterated when the stream receives a listener, and stops
  /// iterating if the listener cancels the subscription.
  ///
  /// If iterating [data] throws an error, the stream ends immediately with
  /// that error. No done event will be sent (iteration is not complete), but no
  /// further data events will be generated either, since iteration cannot
  /// continue.
  ///
  StreamWrapper.fromIterable(Iterable<T> data) : this(new Stream.fromIterable(data));

  /// Checks whether [test] accepts any element provided by this stream.
  ///
  /// Completes the [Future] when the answer is known.
  ///
  /// If this stream reports an error, the [Future] reports that error.
  ///
  /// Stops listening to the stream after the first matching element has been
  /// found.
  ///
  /// Internally the method cancels its subscription after this element. This
  /// means that single-subscription (non-broadcast) streams are closed and
  /// cannot be reused after a call to this method.
  ///
  @override
  Future<bool> any(bool test(T element)) {
    return stream.any(test);
  }

  /// Returns a multi-subscription stream that produces the same events as this.
  ///
  /// The returned stream will subscribe to this stream when its first
  /// subscriber is added, and will stay subscribed until this stream ends,
  /// or a callback cancels the subscription.
  ///
  /// If [onListen] is provided, it is called with a subscription-like object
  /// that represents the underlying subscription to this stream. It is
  /// possible to pause, resume or cancel the subscription during the call
  /// to [onListen]. It is not possible to change the event handlers, including
  /// using [StreamSubscription.asFuture].
  ///
  /// If [onCancel] is provided, it is called in a similar way to [onListen]
  /// when the returned stream stops having listener. If it later gets
  /// a new listener, the [onListen] function is called again.
  ///
  /// Use the callbacks, for example, for pausing the underlying subscription
  /// while having no subscribers to prevent losing events, or canceling the
  /// subscription when there are no listeners.
  ///
  @override
  StreamWrapper<T> asBroadcastStream({void onListen(StreamSubscription<T> subscription), void onCancel(StreamSubscription<T> subscription)}) {
    return new StreamWrapper(stream.asBroadcastStream(onListen: onListen, onCancel: onCancel));
  }

  /// Creates a new stream with the events of a stream per original event.
  ///
  /// This acts like [expand], except that [convert] returns a [Stream]
  /// instead of an [Iterable].
  /// The events of the returned stream becomes the events of the returned
  /// stream, in the order they are produced.
  ///
  /// If [convert] returns `null`, no value is put on the output stream,
  /// just as if it returned an empty stream.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  ///
  @override
  StreamWrapper asyncExpand(Stream convert(T event)) {
    return new StreamWrapper(stream.asyncExpand(convert));
  }

  /// Creates a new stream with each data event of this stream asynchronously
  /// mapped to a new event.
  ///
  /// This acts like [map], except that [convert] may return a [Future],
  /// and in that case, the stream waits for that future to complete before
  /// continuing with its result.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  ///
  @override
  StreamWrapper asyncMap(convert(T event)) {
    return new StreamWrapper(stream.asyncMap(convert));
  }

  /// Checks whether [needle] occurs in the elements provided by this stream.
  ///
  /// Completes the [Future] when the answer is known.
  /// If this stream reports an error, the [Future] will report that error.
  ///
  @override
  Future<bool> contains(Object needle) {
    return stream.contains(needle);
  }

  /// Skips data events if they are equal to the previous data event.
  ///
  /// The returned stream provides the same events as this stream, except
  /// that it never provides two consecutive data events that are equal.
  ///
  /// Equality is determined by the provided [equals] method. If that is
  /// omitted, the '==' operator on the last provided data element is used.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// If a broadcast stream is listened to more than once, each subscription
  /// will individually perform the `equals` test.
  ///
  @override
  StreamWrapper<T> distinct([bool equals(T previous, T next)]) {
    return new StreamWrapper(stream.distinct(equals));
  }

  /// Discards all data on the stream, but signals when it's done or an error
  /// occurred.
  ///
  /// When subscribing using [drain], cancelOnError will be true. This means
  /// that the future will complete with the first error on the stream and then
  /// cancel the subscription.
  ///
  /// In case of a `done` event the future completes with the given
  /// [futureValue].
  ///
  @override
  Future drain([futureValue]) {
    return stream.drain(futureValue);
  }

  /// Returns the value of the [index]th data event of this stream.
  ///
  /// Stops listening to the stream after the [index]th data event has been
  /// received.
  ///
  /// Internally the method cancels its subscription after these elements. This
  /// means that single-subscription (non-broadcast) streams are closed and
  /// cannot be reused after a call to this method.
  ///
  /// If an error event occurs before the value is found, the future completes
  /// with this error.
  ///
  /// If a done event occurs before the value is found, the future completes
  /// with a [RangeError].
  ///
  @override
  Future<T> elementAt(int index) {
    return stream.elementAt(index);
  }

  /// Checks whether [test] accepts all elements provided by this stream.
  ///
  /// Completes the [Future] when the answer is known.
  /// If this stream reports an error, the [Future] will report that error.
  ///
  @override
  Future<bool> every(bool test(T element)) {
    return stream.every(test);
  }

  /// Creates a new stream from this stream that converts each element
  /// into zero or more events.
  ///
  /// Each incoming event is converted to an [Iterable] of new events,
  /// and each of these new events are then sent by the returned stream
  /// in order.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// If a broadcast stream is listened to more than once, each subscription
  /// will individually call `convert` and expand the events.
  ///
  @override
  StreamWrapper expand(Iterable convert(T value)) {
    return new StreamWrapper(stream.expand(convert));
  }

  /// Returns the first element of the stream.
  ///
  /// Stops listening to the stream after the first element has been received.
  ///
  /// Internally the method cancels its subscription after the first element.
  /// This means that single-subscription (non-broadcast) streams are closed
  /// and cannot be reused after a call to this getter.
  ///
  /// If an error event occurs before the first data event, the resulting future
  /// is completed with that error.
  ///
  /// If this stream is empty (a done event occurs before the first data event),
  /// the resulting future completes with a [StateError].
  ///
  /// Except for the type of the error, this method is equivalent to
  /// [:this.elementAt(0):].
  ///
  @override
  Future<T> get first => stream.first;

  /// Finds the first element of this stream matching [test].
  ///
  /// Returns a future that is filled with the first element of this stream
  /// that [test] returns true for.
  ///
  /// If no such element is found before this stream is done, and a
  /// [defaultValue] function is provided, the result of calling [defaultValue]
  /// becomes the value of the future.
  ///
  /// Stops listening to the stream after the first matching element has been
  /// received.
  ///
  /// Internally the method cancels its subscription after the first element that
  /// matches the predicate. This means that single-subscription (non-broadcast)
  /// streams are closed and cannot be reused after a call to this method.
  ///
  /// If an error occurs, or if this stream ends without finding a match and
  /// with no [defaultValue] function provided, the future will receive an
  /// error.
  ///
  @override
  Future firstWhere(bool test(T element), {Object defaultValue()}) {
    return stream.firstWhere(test, defaultValue: defaultValue);
  }

  /** Reduces a sequence of values by repeatedly applying [combine]. */
  @override
  Future fold(initialValue, combine(previous, T element)) {
    return stream.fold(initialValue, combine);
  }

  /// Executes [action] on each data event of the stream.
  ///
  /// Completes the returned [Future] when all events of the stream
  /// have been processed. Completes the future with an error if the
  /// stream has an error event, or if [action] throws.
  ///
  @override
  Future forEach(void action(T element)) {
    return stream.forEach(action);
  }

  /// Creates a wrapper Stream that intercepts some errors from this stream.
  ///
  /// If this stream sends an error that matches [test], then it is intercepted
  /// by the [handle] function.
  ///
  /// The [onError] callback must be of type `void onError(error)` or
  /// `void onError(error, StackTrace stackTrace)`. Depending on the function
  /// type the the stream either invokes [onError] with or without a stack
  /// trace. The stack trace argument might be `null` if the stream itself
  /// received an error without stack trace.
  ///
  /// An asynchronous error [:e:] is matched by a test function if [:test(e):]
  /// returns true. If [test] is omitted, every error is considered matching.
  ///
  /// If the error is intercepted, the [handle] function can decide what to do
  /// with it. It can throw if it wants to raise a new (or the same) error,
  /// or simply return to make the stream forget the error.
  ///
  /// If you need to transform an error into a data event, use the more generic
  /// [Stream.transform] to handle the event by writing a data event to
  /// the output sink.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// If a broadcast stream is listened to more than once, each subscription
  /// will individually perform the `test` and handle the error.
  ///
  @override
  StreamWrapper<T> handleError(Function onError, {bool test(error)}) {
    return new StreamWrapper(stream.handleError(onError, test: test));
  }

  /// Reports whether this stream is a broadcast stream.
  ///
  @override
  bool get isBroadcast => stream.isBroadcast;

  /// Reports whether this stream contains any elements.
  ///
  /// Stops listening to the stream after the first element has been received.
  ///
  /// Internally the method cancels its subscription after the first element.
  /// This means that single-subscription (non-broadcast) streams are closed and
  /// cannot be reused after a call to this getter.
  ///
  @override
  Future<bool> get isEmpty => stream.isEmpty;

  /// Collects string of data events' string representations.
  ///
  /// If [separator] is provided, it is inserted between any two
  /// elements.
  ///
  /// Any error in the stream causes the future to complete with that
  /// error. Otherwise it completes with the collected string when
  /// the "done" event arrives.
  ///
  @override
  Future<String> join([String separator = ""]) {
    return stream.join(separator);
  }

  /// Returns the last element of the stream.
  ///
  /// If an error event occurs before the first data event, the resulting future
  /// is completed with that error.
  ///
  /// If this stream is empty (a done event occurs before the first data event),
  /// the resulting future completes with a [StateError].
  ///
  @override
  Future<T> get last => stream.last;

  /// Finds the last element in this stream matching [test].
  ///
  /// As [firstWhere], except that the last matching element is found.
  /// That means that the result cannot be provided before this stream
  /// is done.
  ///
  @override
  Future lastWhere(bool test(T element), {Object defaultValue()}) {
    return stream.lastWhere(test, defaultValue: defaultValue);
  }

  /** Counts the elements in the stream. */
  @override
  Future<int> get length => stream.length;

  /// Adds a subscription to this stream.
  ///
  /// On each data event from this stream, the subscriber's [onData] handler
  /// is called. If [onData] is null, nothing happens.
  ///
  /// On errors from this stream, the [onError] handler is given a
  /// object describing the error.
  ///
  /// The [onError] callback must be of type `void onError(error)` or
  /// `void onError(error, StackTrace stackTrace)`. If [onError] accepts
  /// two arguments it is called with the stack trace (which could be `null` if
  /// the stream itself received an error without stack trace).
  /// Otherwise it is called with just the error object.
  ///
  /// If this stream closes, the [onDone] handler is called.
  ///
  /// If [cancelOnError] is true, the subscription is ended when
  /// the first error is reported. The default is false.
  ///
  @override
  StreamSubscription<T> listen(void onData(T event), {Function onError, void onDone(), bool cancelOnError}) {
    return stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  /// Creates a new stream that converts each element of this stream
  /// to a new value using the [convert] function.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// If a broadcast stream is listened to more than once, each subscription
  /// will individually execute `map` for each event.
  ///
  @override
  StreamWrapper map(convert(T event)) {
    return new StreamWrapper(stream.map(convert));
  }

  /// Pipe the events of this stream into [streamConsumer].
  ///
  /// The events of this stream are added to `streamConsumer` using
  /// [StreamConsumer.addStream].
  /// The `streamConsumer` is closed when this stream has been successfully added
  /// to it - when the future returned by `addStream` completes without an error.
  ///
  /// Returns a future which completes when the stream has been consumed
  /// and the consumer has been closed.
  ///
  /// The returned future completes with the same result as the future returned
  /// by [StreamConsumer.close].
  /// If the adding of the stream itself fails in some way,
  /// then the consumer is expected to be closed, and won't be closed again.
  /// In that case the returned future completes with the error from calling
  /// `addStream`.
  ///
  @override
  Future pipe(StreamConsumer<T> streamConsumer) {
    return stream.pipe(streamConsumer);
  }

  /// Reduces a sequence of values by repeatedly applying [combine].
  ///
  @override
  Future<T> reduce(T combine(T previous, T element)) {
    return stream.reduce(combine);
  }

  /// Returns the single element.
  ///
  /// If an error event occurs before or after the first data event, the
  /// resulting future is completed with that error.
  ///
  /// If [this] is empty or has more than one element throws a [StateError].
  ///
  @override
  Future<T> get single => stream.single;

  /// Finds the single element in this stream matching [test].
  ///
  /// Like [lastMatch], except that it is an error if more than one
  /// matching element occurs in the stream.
  ///
  @override
  Future<T> singleWhere(bool test(T element)) {
    return stream.singleWhere(test);
  }

  /// Skips the first [count] data events from this stream.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// For a broadcast stream, the events are only counted from the time
  /// the returned stream is listened to.
  ///
  @override
  StreamWrapper<T> skip(int count) {
    return new StreamWrapper(stream.skip(count));
  }

  /// Skip data events from this stream while they are matched by [test].
  ///
  /// Error and done events are provided by the returned stream unmodified.
  ///
  /// Starting with the first data event where [test] returns false for the
  /// event data, the returned stream will have the same events as this stream.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// For a broadcast stream, the events are only tested from the time
  /// the returned stream is listened to.
  ///
  @override
  StreamWrapper<T> skipWhile(bool test(T element)) {
    return new StreamWrapper(stream.skipWhile(test));
  }

  /// Provides at most the first [n] values of this stream.
  ///
  /// Forwards the first [n] data events of this stream, and all error
  /// events, to the returned stream, and ends with a done event.
  ///
  /// If this stream produces fewer than [count] values before it's done,
  /// so will the returned stream.
  ///
  /// Stops listening to the stream after the first [n] elements have been
  /// received.
  ///
  /// Internally the method cancels its subscription after these elements. This
  /// means that single-subscription (non-broadcast) streams are closed and
  /// cannot be reused after a call to this method.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// For a broadcast stream, the events are only counted from the time
  /// the returned stream is listened to.
  ///
  @override
  StreamWrapper<T> take(int count) {
    return new StreamWrapper(stream.take(count));
  }

  /// Forwards data events while [test] is successful.
  ///
  /// The returned stream provides the same events as this stream as long
  /// as [test] returns [:true:] for the event data. The stream is done
  /// when either this stream is done, or when this stream first provides
  /// a value that [test] doesn't accept.
  ///
  /// Stops listening to the stream after the accepted elements.
  ///
  /// Internally the method cancels its subscription after these elements. This
  /// means that single-subscription (non-broadcast) streams are closed and
  /// cannot be reused after a call to this method.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// For a broadcast stream, the events are only tested from the time
  /// the returned stream is listened to.
  ///
  @override
  StreamWrapper<T> takeWhile(bool test(T element)) {
    return new StreamWrapper(stream.takeWhile(test));
  }

  /// Creates a new stream with the same events as this stream.
  ///
  /// Whenever more than [timeLimit] passes between two events from this stream,
  /// the [onTimeout] function is called.
  ///
  /// The countdown doesn't start until the returned stream is listened to.
  /// The countdown is reset every time an event is forwarded from this stream,
  /// or when the stream is paused and resumed.
  ///
  /// The [onTimeout] function is called with one argument: an
  /// [EventSink] that allows putting events into the returned stream.
  /// This `EventSink` is only valid during the call to `onTimeout`.
  ///
  /// If `onTimeout` is omitted, a timeout will just put a [TimeoutException]
  /// into the error channel of the returned stream.
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// If a broadcast stream is listened to more than once, each subscription
  /// will have its individually timer that starts counting on listen,
  /// and the subscriptions' timers can be paused individually.
  ///
  @override
  StreamWrapper timeout(Duration timeLimit, {void onTimeout(EventSink sink)}) {
    return new StreamWrapper(stream.timeout(timeLimit, onTimeout: onTimeout));
  }

  /** Collects the data of this stream in a [List]. */
  @override
  Future<List<T>> toList() {
    return stream.toList();
  }

  /// Collects the data of this stream in a [Set].
  ///
  /// The returned set is the same type as returned by `new Set<T>()`.
  /// If another type of set is needed, either use [forEach] to add each
  /// element to the set, or use
  /// `toList().then((list) => new SomeOtherSet.from(list))`
  /// to create the set.
  ///
  @override
  Future<Set<T>> toSet() {
    return stream.toSet();
  }

  /// Chains this stream as the input of the provided [StreamTransformer].
  ///
  /// Returns the result of [:streamTransformer.bind:] itself.
  ///
  /// The `streamTransformer` can decide whether it wants to return a
  /// broadcast stream or not.
  ///
  @override
  StreamWrapper transform(StreamTransformer<T, dynamic> streamTransformer) {
    return new StreamWrapper(stream.transform(streamTransformer));
  }

  /// Creates a new stream from this stream that discards some data events.
  ///
  /// The new stream sends the same error and done events as this stream,
  /// but it only sends the data events that satisfy the [test].
  ///
  /// The returned stream is a broadcast stream if this stream is.
  /// If a broadcast stream is listened to more than once, each subscription
  /// will individually perform the `test`.
  ///
  @override
  StreamWrapper<T> where(bool test(T event)) {
    return new StreamWrapper(stream.where(test));
  }
}