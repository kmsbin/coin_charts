import 'package:coin_graph/model/coin_model.dart';
import 'package:coin_graph/model/coins_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinConn {
  Future<CoinsModel> coins() async {
    final String urlBase =
        "https://coingecko.p.rapidapi.com/coins/markets?vs_currency=usd&page=1&per_page=100&order=market_cap_desc";
    Response response;
    Options options = Options();
    options.headers = {"x-rapidapi-key": env['API_KEY'], "x-rapidapi-host": "coingecko.p.rapidapi.com"};
    response = await Dio().get(urlBase, options: options);
    CoinsModel coinsModel = CoinsModel([]);
    response.data.forEach((coin) {
      coinsModel.coins.add(CoinModel(
          id: coin["id"].toString(), name: coin["name"], price: coin["current_price"], urlImage: coin["image"]));
    });

    return coinsModel;
  }
}
