import 'package:coin_graph/resources/coin_connect.dart';
import 'package:mobx/mobx.dart';
part 'controller.g.dart';

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  @observable
  int count = 0;

  @action
  addClick() {
    count += 2;
  }

  @computed
  coins() {
    CoinConn conn = CoinConn();
    conn.coins('key');
  }
}
