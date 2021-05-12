import 'package:coin_graph/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

void main() async {
  // await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (ctxt, index) {
                controller.coins();
                return ListTile();
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addClick,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
