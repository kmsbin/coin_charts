import 'package:coin_graph/resources/coin_graph_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CoinGraphScreen extends StatelessWidget {
  final String idCoin;
  CoinGraphScreen({@required this.idCoin}) : super();

  final CoinsGraphConn coinsGraphConn = CoinsGraphConn();
  @override
  Widget build(BuildContext context) {
    coinsGraphConn.dataChart('bitcoin');

    return Scaffold(
      body: Container(),
    );
  }
}
