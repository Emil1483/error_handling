import 'package:error_handling/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'example2_model.dart';

class Example2 extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final _model = Example2Model(
    onError: (Failure failure) => ErrorHandler.showErrorSheet(_scaffoldKey.currentState!, failure),
  );

  void _someAction() {
    _model.showData(_showModalWithData);
  }

  void _showModalWithData(String result) {
    _scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        height: 200,
        color: Colors.grey,
        child: Text(result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('test1'),
        ),
        body: Center(
          child: Material(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(16.0),
            child: Consumer<Example2Model>(
              builder: (context, model, child) => InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: model.waitingTo(_showModalWithData) ? null : _someAction,
                child: Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: model.waitingTo(_showModalWithData)
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 64.0,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
