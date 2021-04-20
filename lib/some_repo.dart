import 'dart:async';
import 'dart:math';

import 'package:error_handling/error_handler.dart';

class SomeRepo {
  Future<String> getData() async {
    await Future.delayed(Duration(seconds: 1));
    if (Random().nextDouble() > 0.5) throw Failure('Goddamn you');
    return 'We got the data';
  }

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

abstract class MustHandleErrors<T> {
  final Function function;

  MustHandleErrors(this.function);
}

class MustHandleErrors1<T> extends MustHandleErrors<T> {
  MustHandleErrors1(FutureOr<T> Function() f) : super(f);

  Future<void> run({required Function(Failure) onFailure, required Function(T) onSuccess}) async {
    return await ErrorHandler.handleErrors<T>(
      run: () async => await function(),
      onFailure: onFailure,
      onSuccess: onSuccess,
    );
  }
}

class MustHandleErrors2<T, A> extends MustHandleErrors<T> {
  MustHandleErrors2(FutureOr<T> Function(A) f) : super(f);

  Future<void> run(A x,
      {required Function(Failure) onFailure, required Function(T) onSuccess}) async {
    return await ErrorHandler.handleErrors<T>(
      run: () async => await function(x),
      onFailure: onFailure,
      onSuccess: onSuccess,
    );
  }
}
