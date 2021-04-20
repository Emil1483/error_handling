import 'package:flutter/material.dart';

import 'package:error_handling/error_handler.dart';
import 'package:error_handling/some_repo.dart';

class Example4 extends StatefulWidget {
  @override
  _Example4State createState() => _Example4State();
}

class _Example4State extends State<Example4> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _someRepo = SomeRepo();
  String? _data;

  void _someAction() async {
    await _someRepo.getData3.run(
      'bruh',
      onFailure: (failure) => ErrorHandler.showErrorSheet(_scaffoldKey.currentState!, failure),
      onSuccess: (data) => setState(() => _data = data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('test1'),
      ),
      body: Center(
        child: Material(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: _someAction,
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: _data != null
                  ? Text(
                      _data!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
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
    );
  }
}
