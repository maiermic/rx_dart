# rx_dart

The [Reactive Extensions](http://reactivex.io) for Dart Streams.

## Usage

A simple usage example:

    import 'package:rx_dart/rx_dart.dart';
    
    main() async {
      var s = new RxStream<int>.fromIterable([1, 2, 3]);
      var r = s.startWith([0]);
      print(await r.toList()); // [0, 1, 2, 3]
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/maiermic/rx_dart/issues
