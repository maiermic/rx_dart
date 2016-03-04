# rx_dart

The [Reactive Extensions](http://reactivex.io) for Dart Streams (unofficial).

## Related Libraries

  - [frankpepermans / rxdart](https://github.com/frankpepermans/rxdart)
  - [danschultz / frappe](https://github.com/danschultz/frappe)
  - [theburningmonk / stream_ext](https://github.com/theburningmonk/stream_ext)
  - [maiermic / stream_test_scheduler](https://github.com/maiermic/stream_test_scheduler)

## Usage

The class `RxStream` extends the build-in Dart class `Stream` and provides additional methods:

  - [combineLatest]
  - [concat]
  - [concatMap]
  - [debounce]
  - [delay]
  - [doOnNext]
  - [flatMap]
  - [flatMapLatest]
  - [merge]
  - [scan]
  - [startWith]
  - [switchLatest]
  - [takeUntil]
  - [withLatestFrom]
  - [zip]
  - [zipArray]

You can convert `Stream`, `Future` and `Iterable` with the function `rx` to `RxStream` or use a named constructor.
For example is

    new RxStream<int>.fromIterable([1, 2, 3])
    
the same as

    rx([1, 2, 3])

Furthermore, you can use several functions to create an `RxStream`

  - [empty]
  - [interval]
  - [just]

or to combine `Stream`s

  - [combineLatest]
  - [concat]
  - [merge]
  - [zip]
  - [zipArray]


Look at the [examples] and [tests] to see them in action. 


[examples]: https://github.com/maiermic/rx_dart/tree/master/example
[tests]: https://github.com/maiermic/rx_dart/tree/master/test

[combineLatest]: http://reactivex.io/documentation/operators/combinelatest.html
[concat]: http://reactivex.io/documentation/operators/concat.html
[concatMap]: http://reactivex.io/documentation/operators/flatmap.html
[debounce]: http://reactivex.io/documentation/operators/debounce.html
[delay]: http://reactivex.io/documentation/operators/delay.html
[doOnNext]: http://reactivex.io/documentation/operators/do.html
[empty]: http://reactivex.io/documentation/operators/empty-never-throw.html
[flatMap]: http://reactivex.io/documentation/operators/flatmap.html
[flatMapLatest]: http://reactivex.io/documentation/operators/flatmap.html 
[interval]: http://reactivex.io/documentation/operators/interval.html 
[just]: http://reactivex.io/documentation/operators/just.html 
[merge]: http://reactivex.io/documentation/operators/merge.html 
[scan]: http://reactivex.io/documentation/operators/scan.html 
[startWith]: http://reactivex.io/documentation/operators/startwith.html 
[switchLatest]: http://reactivex.io/documentation/operators/switch.html 
[takeUntil]: http://reactivex.io/documentation/operators/takeuntil.html
[withLatestFrom]: http://reactivex.io/documentation/operators/combinelatest.html 
[zip]: http://reactivex.io/documentation/operators/zip.html 
[zipArray]: http://reactivex.io/documentation/operators/zip.html


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/maiermic/rx_dart/issues
