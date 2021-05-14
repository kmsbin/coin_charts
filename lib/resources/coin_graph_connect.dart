import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinsGraphConn {
  dataChart(final String idCoin) async {
    final Options options = Options(headers: {
      "x-rapidapi-key": env['API_KEY'],
      "x-rapidapi-host": "coingecko.p.rapidapi.com",
    });
    final String urlBase = "https://coingecko.p.rapidapi.com/coins/$idCoin/market_chart";

    final Response response =
        await Dio().get(urlBase, options: options, queryParameters: {'vs_currency': "brl", 'days': '2'});
    print(response.data);
  }
}
