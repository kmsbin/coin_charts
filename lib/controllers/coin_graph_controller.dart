import 'package:coin_graph/model/coin_chart_model.dart';
import 'package:coin_graph/resources/coin_graph_connect.dart';
import 'package:mobx/mobx.dart';
part 'coin_graph_controller.g.dart';

class CoinGraphController = CoinGraphControllerBase with _$CoinGraphController;

abstract class CoinGraphControllerBase with Store {
  @observable
  String vsCurrency = 'usd';

  @observable
  String currentPrice = '';

  @observable
  String idCoin = 'bitcoin';

  @observable
  CoinChartModel coinChartModel = CoinChartModel(id: 'bitcoin');

  @action
  vsCurrencyCoin(String updateVsCurrent) => vsCurrency = updateVsCurrent;

  @action
  coin(String updateCoin) => idCoin = updateCoin;

  @action
  fetchCoinGraph({String coin, String vsCurrency, String days = '1'}) async {
    this.idCoin = coin;

    fetchCurrentPrice();
    coinChartModel = CoinChartModel(id: coin);
    coinChartModel = await CoinsGraphConn().dataChart(coin, vsCurrency, days);
  }

  @action
  fetchCoinGraphFromUnixTime({String to, String from}) async {
    fetchCurrentPrice();
    coinChartModel = CoinChartModel(id: idCoin);
    coinChartModel = await CoinsGraphConn().dataChartFromUnixTime(FetchCoin(
      idCoin: idCoin,
      vsCurrency: vsCurrency,
      fromUnixTime: from,
      toUnixTime: to,
    ));
    ;
  }

  @action
  fetchCurrentPrice() async {
    currentPrice = await CoinsGraphConn().getCurrentPrice(idCoin: idCoin, vsCurrency: vsCurrency);
  }

  String titlePrepare(double title) {
    if (title < 5) {
      return title.toStringAsFixed(3);
    } else if (title > 1000) {
      return title.toStringAsFixed(1) + 'k';
    }
    return title.toStringAsFixed(1);
  }

  dispose() {}
}
