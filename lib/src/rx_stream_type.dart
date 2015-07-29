// Copyright (c) 2015, <Michael Maier>. All rights reserved. Use of this source code
// is governed by a MIT-style license that can be found in the LICENSE file.

part of rx_dart;

/// Return type mixin used with a sub class of [StreamWrapper].
///
/// This class can be used as a mixin with a concrete sub class of
/// [StreamWrapper] to provide concrete return types to some of the methods
/// inherited from [StreamWrapper].
///
/// [Stream] owns methods that return a stream of the same type (for example
/// `skip`) or an unknown type (for example `map`).
abstract class StreamWrapperType<T, W extends StreamWrapper<T, W>> {
  W asBroadcastStream({void onListen(StreamSubscription<T> subscription),
                      void onCancel(StreamSubscription<T> subscription)});

  W distinct([bool equals(T previous, T next)]);

  W handleError(Function onError, {bool test(error)});

  W skip(int count);

  W skipWhile(bool test(T element));

  W take(int count);

  W takeWhile(bool test(T element));

  W where(bool test(T event));
}