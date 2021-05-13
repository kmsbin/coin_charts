import 'package:coin_graph/model/coin_model.dart';
import 'package:coin_graph/model/coins_model.dart';
import 'package:coin_graph/resources/coin_connect.dart';
import 'package:mobx/mobx.dart';
part 'controller.g.dart';

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  @observable
  List<CoinModel> _coins = [];

  get coins => _coins;

  ControllerBase() : super() {
    fetchCoins();
  }

  @action
  fetchCoins() async {
    CoinConn conn = CoinConn();
    CoinsModel coinsModel = await conn.coins();
    _coins = coinsModel.coins;
  }
}
