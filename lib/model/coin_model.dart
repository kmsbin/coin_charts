import 'package:flutter/foundation.dart';

class CoinModel {
  final String id;
  final String name;
  final dynamic price;
  final String urlImage;
  final String priceChangePercent;

  const CoinModel({@required this.id, @required this.priceChangePercent, @required this.name, @required this.price, @required this.urlImage});
}
