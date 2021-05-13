import 'package:coin_graph/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

void main() async {
  await DotEnv.load(fileName: ".env");
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
      home: CoinList(),
    );
  }
}

class CoinList extends StatelessWidget {
  final controller = Controller();
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    controller.fetchCoins();
    double offSetBuffer = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(child: Observer(
        builder: (BuildContext context) {
          return ListView.builder(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: controller.coins.length,
              itemBuilder: (ctxt, index) {
                if (scrollController.offset < 0) {
                  if (offSetBuffer > 0) {
                    print('1 negativo');
                    controller.fetchCoins();
                  } else {
                    offSetBuffer = scrollController.offset;
                  }
                } else {
                  offSetBuffer = scrollController.offset;
                }
                return ListTile(
                  leading: Image.network(controller.coins[index].urlImage),
                  title: Text(controller.coins[index].name),
                  subtitle: Text(controller.coins[index].price.toString()),
                );
              });
        },
      )),
    );
  }
}
