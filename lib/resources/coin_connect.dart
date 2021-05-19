import 'package:coin_graph/model/coin_model.dart';
import 'package:coin_graph/model/coins_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinConn {
  Future<CoinsModel> coins() async {
    final String urlBase =
        "https://coingecko.p.rapidapi.com/coins/markets?vs_currency=usd&page=1&per_page=100&order=market_cap_desc";
    Options options = Options(headers: {
      "x-rapidapi-key": env['API_KEY'],
      "x-rapidapi-host": "coingecko.p.rapidapi.com",
    });
    Response response = await Dio().get(urlBase,
        options: options,
        queryParameters: {"sparkline": "true", "price_change_percentage": "1h", "order": "market_cap_desc"});
    CoinsModel coinsModel = CoinsModel([]);
    response.data.forEach((coin) {
      coinsModel.coins.add(CoinModel(
          id: coin["id"].toString(),
          priceChangePercent: coin["price_change_percentage_1h_in_currency"].toString(),
          name: coin["name"],
          price: coin["current_price"],
          urlImage: coin["image"]));
    });

    return coinsModel;
  }
}
