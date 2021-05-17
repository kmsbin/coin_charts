import 'dart:math';

import 'package:coin_graph/controllers/coin_graph_controller.dart';
import 'package:coin_graph/resources/coin_graph_connect.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class CoinGraphScreen extends StatelessWidget {
  final String idCoin;
  CoinGraphScreen({@required this.idCoin}) : super();

  final CoinGraphController coinGraphController = CoinGraphController();

  @override
  Widget build(BuildContext context) {
    coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd');
    return Scaffold(
        body: Center(
      child: Container(
          child: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Observer(builder: (ctxt) {
                if (coinGraphController?.coinChartModel?.spots?.isNotEmpty ?? false) {
                  return Container(
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(
                            show: true, border: Border(bottom: BorderSide(width: 0.5, color: Colors.black26))),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                              maxContentWidth: 100,
                              fitInsideHorizontally: true,
                              getTooltipItems: (List<LineBarSpot> linesBarSpots) {
                                List<LineTooltipItem> lineTooltipItem = [];
                                linesBarSpots.forEach((lineSpot) {
                                  lineTooltipItem.add(LineTooltipItem(
                                      lineSpot.y.toStringAsFixed(5), TextStyle(color: Colors.orangeAccent)));
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
                  return Container(child: CircularProgressIndicator());
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
                      coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd', days: '1');
                    },
                    child: Container(child: Text('1h')),
                  ),
                  GestureDetector(
                    onTap: () {
                      coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd', days: '7');
                    },
                    child: Container(child: Text('1w')),
                  ),
                  GestureDetector(
                    onTap: () {
                      coinGraphController.fetchCoinGraph(coin: idCoin, vsCurrency: 'usd', days: '30');
                    },
                    child: Container(child: Text('1m')),
                  ),
                  GestureDetector(
                    onTap: () {
                      coinGraphController.fetchCoinGraph(
                        coin: idCoin,
                        vsCurrency: 'usd',
                      );
                    },
                    child: Container(child: Text('1y')),
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
