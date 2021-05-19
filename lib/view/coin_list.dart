import 'package:coin_graph/controllers/controller.dart';
import 'package:coin_graph/view/coin_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CoinList extends StatelessWidget {
  final controller = Controller();
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    controller.fetchCoins();
    double offSetBuffer = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin chart'),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoinGraphScreen(
                              idCoin: controller.coins[index].id,
                              price: controller.coins[index].price.toString(),
                              pricePercent: controller.coins[index].priceChangePercent)),
                    );
                  },
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
