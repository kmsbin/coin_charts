import 'package:flutter/foundation.dart';

class CoinModel {
  final String id;
  final String name;
  final dynamic price;
  final String urlImage;

  const CoinModel({@required this.id, @required this.name, @required this.price, @required this.urlImage});
}
