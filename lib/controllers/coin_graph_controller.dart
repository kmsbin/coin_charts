import 'package:coin_graph/model/coin_chart_model.dart';
import 'package:coin_graph/resources/coin_graph_connect.dart';
import 'package:mobx/mobx.dart';
part 'coin_graph_controller.g.dart';

class CoinGraphController = CoinGraphControllerBase with _$CoinGraphController;

abstract class CoinGraphControllerBase with Store {
  @observable
  String vsCurrency = 'usd';

  @observable
  String idCoin = 'bitcoin';

  @observable
  CoinChartModel coinChartModel = CoinChartModel(id: 'bitcoin');

  @action
  fetchCoinGraph({String coin, String vsCurrency, String days = '1'}) async {
    this.vsCurrency = vsCurrency;
    this.idCoin = coin;

    coinChartModel = CoinChartModel(id: coin);
    coinChartModel = await CoinsGraphConn().dataChart(coin, vsCurrency, days);
  }

  @action
  fetchCoinGraphFromUnixTime({String coin, String vsCurrency, String to, String from}) async {
    vsCurrency = vsCurrency ?? this.vsCurrency;
    coin = coin ?? this.idCoin;

    coinChartModel = CoinChartModel(id: coin);
    coinChartModel = await CoinsGraphConn().dataChartFromUnixTime(FetchCoin(
      idCoin: coin,
      vsCurrency: vsCurrency,
      fromUnixTime: from,
      toUnixTime: to,
    ));
    this.vsCurrency = vsCurrency;
    this.idCoin = coin;
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
