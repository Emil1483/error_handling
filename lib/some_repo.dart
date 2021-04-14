import 'dart:math';

import 'package:error_handling/error_handler.dart';

class SomeRepo {
  Future<String> getData() async {
    // return await ErrorHandler.catchCommonErrors(() async {
    await Future.delayed(Duration(seconds: 1));
    if (Random().nextDouble() > 0.5) throw Failure('Norway is Better than Germany!');
    return 'We got the data';
    // });
  }
}
