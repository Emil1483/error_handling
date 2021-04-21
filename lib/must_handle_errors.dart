import 'dart:async';

import 'package:error_handling/error_handler.dart';

abstract class MustHandleErrors<T> {
  final Function function;

  MustHandleErrors(this.function);
}

class MustHandleErrorsNoOutput1 extends MustHandleErrors {
  MustHandleErrorsNoOutput1(FutureOr Function() f) : super(f);

  Future<void> run({required Function(Failure) onFailure, required Function() onSuccess}) async {
    return await ErrorHandler.handleErrors(
      run: () async => await function(),
      onFailure: onFailure,
      onSuccess: (_) {},
    );
  }
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
