import 'package:coin_graph/controllers/coin_graph_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';

class CoinGraphScreen extends StatelessWidget {
  final String idCoin;
  final String price;
  final String pricePercent;
  CoinGraphScreen({@required this.price, @required this.pricePercent, @required this.idCoin}) : super();

  Map<String, String> lastRangeTime = {
    'to': '',
    'from': '',
  };

  Map<String, String> getInitUnixTime() {
    Map<String, String> lastRangeTime = {};
    var oneHourAgo = DateTime.now().subtract(Duration(hours: Duration.minutesPerHour * 6)).millisecondsSinceEpoch.toString();
    var currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    oneHourAgo = oneHourAgo.substring(0, oneHourAgo.length - 3);
    currentTime = currentTime.substring(0, currentTime.length - 3);

    lastRangeTime['from'] = oneHourAgo;
    lastRangeTime['to'] = currentTime;
    return lastRangeTime;
  }

  final CoinGraphController coinGraphController = CoinGraphController();
  @override
  Widget build(BuildContext context) {
    coinGraphController.coin(idCoin);
    lastRangeTime = getInitUnixTime();

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Observer(builder: (context) {
                          return Text('${coinGraphController.currentPrice}', style: TextStyle(fontSize: 30));
                        }),
                        Text(
                          percent,
                          style: TextStyle(color: pricePercentNum > 0 ? Colors.green : Colors.red),
                        )
                      ],
                    ),
                    Container(
                      child: Row(
                        children: [
                          // TextField(),
                          // TextField(),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: Observer(builder: (context) {
                                return DropdownButton(
                                    onChanged: (String coin) {
                                      coinGraphController.vsCurrencyCoin(coin);
                                      coinGraphController.fetchCoinGraphFromUnixTime(from: lastRangeTime['from'], to: lastRangeTime['to']);
                                    },
                                    onTap: () {},
                                    value: coinGraphController.vsCurrency,
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text('Dólar'),
                                        value: 'usd',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Yene'),
                                        value: 'jpy',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Real'),
                                        value: 'brl',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Euro'),
                                        value: 'eur',
                                      ),
                                    ]);
                              }),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Observer(builder: (ctxt) {
                      if (coinGraphController?.coinChartModel?.spots?.isNotEmpty ?? false) {
                        return Container(
                          child: LineChart(
                              LineChartData(
                                borderData: FlBorderData(show: false, border: Border(bottom: BorderSide(width: 0.5, color: Colors.black26))),
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                      maxContentWidth: 100,
                                      fitInsideHorizontally: true,
                                      getTooltipItems: (List<LineBarSpot> linesBarSpots) {
                                        List<LineTooltipItem> lineTooltipItem = [];
                                        linesBarSpots.forEach((lineSpot) {
                                          lineTooltipItem.add(LineTooltipItem(lineSpot.y.toStringAsFixed(5), TextStyle(color: Color(0xff8E3670))));
                                        });
                                        // print(linesBarSpots.);
                                        return lineTooltipItem;
                                      }),
                                ),
                                titlesData: FlTitlesData(
                                    leftTitles: SideTitles(
                                        reservedSize: 40,
                                        getTextStyles: (title) => TextStyle(color: Colors.white60),
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
                                    gradientFrom: Offset(1, 1),
                                    gradientTo: Offset(0, 0),
                                    colorStops: [0, 0.5, 1],
                                    colors: [Color(0xff8E3670), Color(0xff7E44C8)],
                                    belowBarData: BarAreaData(
                                      show: false,
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
                              swapAnimationDuration: Duration(milliseconds: 1500),
                              swapAnimationCurve: Curves.linear),
                        );
                      } else {
                        return Center(
                            child: Container(
                                child: Lottie.asset(
                          'assets/loading_animation.json',
                          repeat: true,
                          animate: true,
                        )));
                      }
                    }),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
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

                          lastRangeTime['from'] = oneHourAgo;
                          lastRangeTime['to'] = currentTime;

                          coinGraphController.fetchCoinGraphFromUnixTime(from: oneHourAgo, to: currentTime);
                        },
                        child: Container(child: Text('1H')),
                      ),
                      GestureDetector(
                        onTap: () {
                          coinGraphController.fetchCoinGraph(coin: idCoin, days: '1');
                        },
                        child: Container(child: Text('1D')),
                      ),
                      GestureDetector(
                        onTap: () {
                          coinGraphController.fetchCoinGraph(coin: idCoin, days: '7');
                        },
                        child: Container(child: Text('1W')),
                      ),
                      GestureDetector(
                        onTap: () {
                          coinGraphController.fetchCoinGraph(coin: idCoin, days: '30');
                        },
                        child: Container(child: Text('1M')),
                      ),
                      GestureDetector(
                        onTap: () {
                          var oneYearAgo = DateTime.now().subtract(Duration(days: (Duration.hoursPerDay * 24) * 365)).millisecondsSinceEpoch.toString();
                          var currentTime = DateTime.now().millisecondsSinceEpoch.toString();
                          oneYearAgo = oneYearAgo.substring(0, oneYearAgo.length - 3);
                          currentTime = currentTime.substring(0, currentTime.length - 3);

                          lastRangeTime['from'] = oneYearAgo;
                          lastRangeTime['to'] = currentTime;

                          coinGraphController.fetchCoinGraphFromUnixTime(from: oneYearAgo, to: currentTime);
                        },
                        child: Container(child: Text('1Y')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    ));
  }
}
