import 'package:coin_graph/controllers/coin_graph_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CoinGraphScreen extends StatelessWidget {
  final String idCoin;
  final String price;
  final String pricePercent;
  CoinGraphScreen({@required this.price, @required this.pricePercent, @required this.idCoin}) : super();

  final CoinGraphController coinGraphController = CoinGraphController();
  @override
  Widget build(BuildContext context) {
    print(pricePercent);
    double pricePercentNum = double.parse(pricePercent) * 10;
    String percent = (double.parse(pricePercent) * 10).toStringAsPrecision(3) + '%';

    coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd');
    return Scaffold(
        body: Center(
      child: Container(
          padding: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text('\$${this.price}', style: TextStyle(fontSize: 30)),
                    Text(
                      percent,
                      style: TextStyle(color: pricePercentNum > 0 ? Colors.green : Colors.red),
                    )
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Observer(builder: (ctxt) {
                    if (coinGraphController?.coinChartModel?.spots?.isNotEmpty ?? false) {
                      return Container(
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(width: 0.5, color: Colors.black26))),
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                  maxContentWidth: 100,
                                  fitInsideHorizontally: true,
                                  getTooltipItems: (List<LineBarSpot> linesBarSpots) {
                                    List<LineTooltipItem> lineTooltipItem = [];
                                    linesBarSpots.forEach((lineSpot) {
                                      lineTooltipItem.add(LineTooltipItem(lineSpot.y.toStringAsFixed(5), TextStyle(color: Colors.orangeAccent)));
                                    });
                                    // print(linesBarSpots.);
                                    return lineTooltipItem;
                                  }),
                            ),
                            titlesData: FlTitlesData(
                                leftTitles: SideTitles(
                                    reservedSize: 40,
                                    getTitles: coinGraphController.titlePrepare,
                                    showTitles: true,
                                    interval: coinGraphController.coinChartModel.titleInterval),
                                bottomTitles: SideTitles(showTitles: false)),
                            minY: coinGraphController.coinChartModel.minPrice,
                            gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (index) {
                                  return FlLine(strokeWidth: 0);
                                }),
                            lineBarsData: [
                              LineChartBarData(
                                spots: coinGraphController.coinChartModel.spots,
                                isCurved: true,
                                barWidth: 1.5,
                                gradientFrom: Offset(0, 1),
                                gradientTo: Offset(0, 1),
                                colorStops: [0.25, 0.75],
                                colors: [
                                  Colors.orange,
                                ],
                                belowBarData: BarAreaData(
                                  show: true,
                                  applyCutOffY: false,
                                  colors: [Colors.blue.withOpacity(0.3), Colors.lightBlue.withOpacity(0.3)],
                                ),
                                aboveBarData: BarAreaData(
                                  show: false,
                                ),
                                dotData: FlDotData(
                                  show: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Container(
                            constraints: BoxConstraints(
                              maxHeight: 50,
                              maxWidth: 50,
                            ),
                            child: Container(child: CircularProgressIndicator())),
                      );
                    }
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          var oneHourAgo = DateTime.now().subtract(Duration(hours: Duration.minutesPerHour * 6)).millisecondsSinceEpoch.toString();
                          var currentTime = DateTime.now().millisecondsSinceEpoch.toString();
                          oneHourAgo = oneHourAgo.substring(0, oneHourAgo.length - 3);
                          currentTime = currentTime.substring(0, currentTime.length - 3);

                          print(oneHourAgo);
                          print(currentTime);

                          coinGraphController.fetchCoinGraphFromUnixTime(coin: idCoin, vsCurrency: 'usd', from: oneHourAgo, to: currentTime);
                        },
                        child: Container(child: Text('1H')),
                      ),
                      GestureDetector(
                        onTap: () {
                          coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd', days: '1');
                        },
                        child: Container(child: Text('1D')),
                      ),
                      GestureDetector(
                        onTap: () {
                          coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd', days: '7');
                        },
                        child: Container(child: Text('1W')),
                      ),
                      GestureDetector(
                        onTap: () {
                          coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd', days: '30');
                        },
                        child: Container(child: Text('1M')),
                      ),
                      GestureDetector(
                        onTap: () {
                          var oneYearAgo = DateTime.now().subtract(Duration(days: (Duration.hoursPerDay * 24) * 365)).millisecondsSinceEpoch.toString();
                          var currentTime = DateTime.now().millisecondsSinceEpoch.toString();
                          oneYearAgo = oneYearAgo.substring(0, oneYearAgo.length - 3);
                          currentTime = currentTime.substring(0, currentTime.length - 3);

                          print(oneYearAgo);
                          print(currentTime);

                          coinGraphController.fetchCoinGraphFromUnixTime(coin: idCoin, vsCurrency: 'usd', from: oneYearAgo, to: currentTime);
                        },
                        child: Container(child: Text('1Y')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    ));
  }
}
