import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dartz/dartz.dart';
import 'package:error_handling/error_sheet.dart';
import 'package:flutter/material.dart';

class Failure implements Exception {
  final String message;

  Failure(this.message);
}

class ErrorHandler {
  static Future catchCommonErrors(Function function, {bool checkInternet = true}) async {
    try {
      return await function();
    } on Failure {
      rethrow;
    } on SocketException {
      throw Failure('no internet');
    }
    // on PlatformException catch (e) {
    //   throw  Failure(ErrorHandler.handlePlatformException(e));
    // }
    catch (e, stacktrace) {
      print(stacktrace);
      print(e);
      throw Failure('unknown error');
    }
  }

  static void showErrorSheet(ScaffoldState scaffoldState, Failure failure) {
    scaffoldState.showBottomSheet(
      (context) => ErrorSheet(failure.message),
    );
  }

  static Future handleErrors<T>({
    required Future<T> Function() run,
    required Function(Failure) onFailure,
    required Function(T) onSuccess,
  }) async {
    await Task(run).attempt().mapLeftToFailure().run().then((either) async {
      await either.fold(
        (failure) async => await onFailure(failure),
        (success) async => await onSuccess(success),
      );
    });
  }

  static Future<Either<Failure, T>> getEither<T>(Future<T> Function() run) =>
      Task<T>(run).attempt().mapLeftToFailure().mapRightToSuccess<T>().run();
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map<Either<Failure, U>>(
      (either) => either.leftMap((obj) {
        try {
          return obj as Failure;
        } catch (e) {
          throw obj;
        }
      }),
    );
  }
}

extension TaskY<U extends Either<Failure, R>, R> on Task<U> {
  Task<Either<Failure, V>> mapRightToSuccess<V>() {
    return this.map(
      (either) => either.map((obj) {
        try {
          return obj as V;
        } catch (e) {
          throw obj as Object;
        }
      }),
    );
  }
}

abstract class GetShowDataModel<T> extends ChangeNotifier {
  Either<Failure, T>? result;
  Function(T)? _onLoadingComplete;
  bool _loading = false;

  @protected
  Future<T> getData();

  bool get _waitingToShowData => _onLoadingComplete != null;
  bool waitingTo(Function(T) function) => function == _onLoadingComplete;

  final Function1<Failure, void> _onError;
  final bool shouldUpdateWaitingOnSuccess;

  GetShowDataModel(this._onError, {this.shouldUpdateWaitingOnSuccess = true}) {
    loadData();
  }

  @protected
  void stopLoading() {
    _onLoadingComplete = null;
    notifyListeners();
  }

  Future<void> loadData() async {
    _loading = true;
    await _getDataAndThen();
    notifyListeners();
    if (_waitingToShowData) showData(_onLoadingComplete!);
  }

  void showData(Function(T) onSuccess) {
    if (result == null) {
      if (!_loading) loadData();
      _onLoadingComplete = onSuccess;
      notifyListeners();
      return;
    }
    result!.fold(
      (failure) {
        if (_waitingToShowData) {
          _showError(failure);
        } else {
          _tryAgain(onSuccess);
        }
      },
      (success) {
        _onSuccessWrapper(success, onSuccess);
      },
    );
  }

  Future<void> _getDataAndThen({
    Function1<Failure, void>? onFailure,
    Function1<T, void>? onSuccess,
  }) async {
    result = await ErrorHandler.getEither<T>(getData);
    result!.fold(onFailure ?? (failure) {}, onSuccess ?? (success) {});
  }

  void _showError(Failure failure) {
    _onError(failure);
    _onLoadingComplete = null;
    notifyListeners();
  }

  void _tryAgain(Function(T) onSuccess) {
    _onLoadingComplete = onSuccess;
    notifyListeners();
    _getDataAndThen(
      onFailure: _showError,
      onSuccess: (success) => _onSuccessWrapper(success, onSuccess),
    );
  }

  void _onSuccessWrapper(T data, Function(T) onSuccess) {
    if (shouldUpdateWaitingOnSuccess && _waitingToShowData) {
      _onLoadingComplete = null;
      notifyListeners();
    }
    onSuccess(data);
  }
}
