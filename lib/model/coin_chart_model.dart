import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class CoinChartModel {
  final String id;
  double minPrice;
  List<FlSpot> spots = [];

  CoinChartModel({
    @required this.id,
  });
}
