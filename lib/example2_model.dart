import 'package:error_handling/error_handler.dart';
import 'package:error_handling/some_repo.dart';

class Example2Model extends GetShowDataModel<String> {
  final _someRepo = SomeRepo();

  Example2Model({required onError}) : super(onError);

  @override
  Future<String> getData() => _someRepo.getData();
}
