import 'dart:async';
import 'dart:math';

import 'package:error_handling/error_handler.dart';
import 'package:error_handling/must_handle_errors.dart';

class SomeRepo {
  Future<String> getData() async {
    await Future.delayed(Duration(seconds: 1));
    if (Random().nextDouble() > 0.5) throw Failure('Goddamn you');
    return 'We got the data';
  }

  final doSomething = MustHandleErrors0(() async {
    print('bruh');
    if (Random().nextDouble() > 0.5) throw Failure('oops lol');
  });

  final getData2 = MustHandleErrors1<String>(() async {
    await Future.delayed(Duration(seconds: 1));
    if (Random().nextDouble() > 0.5) throw Failure('Fuck you');
    return 'We got the data';
  });

  final getData3 = MustHandleErrors2<String, String>((text) async {
    await Future.delayed(Duration(seconds: 1));
    if (Random().nextDouble() > 0.5) throw Failure('Damn you');
    return 'We got the data: $text';
  });
}