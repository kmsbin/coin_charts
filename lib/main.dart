import 'package:coin_graph/view/coin_graph.dart';
import 'package:coin_graph/view/coin_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CoinList(),
        '/coin_graph': (context) => CoinGraphScreen(
              idCoin: 'bitcoin',
              price: '00.00',
            )
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Color(0xff1B1B1B),
        cardColor: Color(0xff1B1B1B),
        scaffoldBackgroundColor: Color(0xff161616),
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
    );
  }
}
