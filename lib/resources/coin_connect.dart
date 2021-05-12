import 'package:dio/dio.dart';

class CoinConn {
  coins(String key) async {
    final String urlBase =
        "https://coingecko.p.rapidapi.com/coins/markets?vs_currency=usd&page=1&per_page=100&order=market_cap_desc";
    Response response;
    Options options = Options();
    options.headers = {"x-rapidapi-key": key, "x-rapidapi-host": "coingecko.p.rapidapi.com"};
    response = await Dio().get(urlBase, options: options);

    print(response.data);
  }
}
