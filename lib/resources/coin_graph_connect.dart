import 'package:coin_graph/model/coin_chart_model.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinsGraphConn {
  Map<String, String> currencys = {'usd': '\$', 'jpy': '¥', 'brl': 'R\$', 'eur': '€'};

  final Options options = Options(headers: {
    "x-rapidapi-key": env['API_KEY'],
    "x-rapidapi-host": "coingecko.p.rapidapi.com",
  });

  Future<CoinChartModel> dataChart(final String idCoin, final String vsCurrency, final String period) async {
    final String urlBase = "https://coingecko.p.rapidapi.com/coins/$idCoin/market_chart";
    Map<String, String> parameters = {
      'vs_currency': vsCurrency,
      'days': period,
      "price_change_percentage": "1h",
    };
    final Response response = await Dio().get(urlBase, options: options, queryParameters: parameters);

    CoinChartModel _coinChartModel = setDataChart(response.data, idCoin);

    return _coinChartModel;
  }

  CoinChartModel setDataChart(data, id) {
    CoinChartModel coinChartModel = CoinChartModel(id: id);
    coinChartModel.minPrice = data['prices'].first.first.toDouble();
    data['prices'].forEach((item) {
      coinChartModel.spots.add(FlSpot(item.first.toDouble(), item.last.toDouble()));
      coinChartModel.minPrice = coinChartModel.minPrice > item.last ? item.last : coinChartModel.minPrice;
      coinChartModel.maxPrice =
          coinChartModel.maxPrice < item.last.toDouble() ? item.last.toDouble() : coinChartModel.maxPrice;
    });
    coinChartModel.titleInterval = (coinChartModel.maxPrice - coinChartModel.minPrice) / 4;
    coinChartModel.minPrice *= 0.99;

    return coinChartModel;
  }

  Future<CoinChartModel> dataChartFromUnixTime(FetchCoin fetchCoinData) async {
    final String urlBase = "https://coingecko.p.rapidapi.com/coins/${fetchCoinData.idCoin}/market_chart/range";
    Map<String, String> parameters = {
      'vs_currency': fetchCoinData.vsCurrency,
      'from': fetchCoinData.fromUnixTime,
      'to': fetchCoinData.toUnixTime
    };
    final Response response = await Dio().get(urlBase, options: options, queryParameters: parameters);

    CoinChartModel coinChartModel = setDataChart(response.data, fetchCoinData.idCoin);

    return coinChartModel;
  }

  Future<String> getCurrentPrice({final String idCoin, final String vsCurrency}) async {
    final String urlBase = "https://coingecko.p.rapidapi.com/coins/$idCoin";
    Map<String, String> parameters = {'vs_currency': vsCurrency};
    final Response response = await Dio().get(urlBase, options: options, queryParameters: parameters);

    return '${currencys[vsCurrency]} ${response.data['market_data']['current_price'][vsCurrency].toString()}';
  }
}
