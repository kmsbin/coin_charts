import 'package:coin_graph/model/coin_chart_model.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinsGraphConn {
  Future<CoinChartModel> dataChart(final String idCoin) async {
    final Options options = Options(headers: {
      "x-rapidapi-key": env['API_KEY'],
      "x-rapidapi-host": "coingecko.p.rapidapi.com",
    });
    final String urlBase = "https://coingecko.p.rapidapi.com/coins/$idCoin/market_chart";

    final Response response = await Dio().get(urlBase, options: options, queryParameters: {'vs_currency': "usd", 'days': '1'});
    // print(response.data);
    CoinChartModel _coinChartModel = CoinChartModel(id: idCoin);
    List<double> yAxis = [];
    response.data['prices'].forEach((item) {
      _coinChartModel.spots.add(FlSpot(item.first.toDouble(), item.last.toDouble()));
      yAxis.add(item.last.toDouble());
    });
    _coinChartModel.minPrice = yAxis.reduce((first, last) => first > last ? last : first) * 0.99;

    return _coinChartModel;
  }
}
