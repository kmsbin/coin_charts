import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class CoinChartModel {
  String id;
  String price;
  double minPrice = 0.0;
  double maxPrice = 0.0;
  double titleInterval = 0.0;
  String priceChangePercentage;
  List<FlSpot> spots = [];

  CoinChartModel({
    @required this.id,
  });
}

class FetchCoin {
  String idCoin;
  String toUnixTime;
  String fromUnixTime;
  String vsCurrency;

  FetchCoin({
    @required this.idCoin,
    @required this.toUnixTime,
    @required this.fromUnixTime,
    @required this.vsCurrency,
  });
}
