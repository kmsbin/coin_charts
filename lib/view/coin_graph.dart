import 'dart:math';

import 'package:coin_graph/resources/coin_graph_connect.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CoinGraphScreen extends StatelessWidget {
  final String idCoin;
  CoinGraphScreen({@required this.idCoin}) : super();

  final CoinsGraphConn coinsGraphConn = CoinsGraphConn();
  @override
  Widget build(BuildContext context) {
    coinsGraphConn.dataChart(idCoin);

    return Scaffold(
        body: Center(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SafeArea(
            child: Center(
              child: FutureBuilder(
                  future: coinsGraphConn.dataChart(idCoin),
                  builder: (ctxt, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(width: 0.5, color: Colors.black26))),
                            lineTouchData: LineTouchData(enabled: true),
                            titlesData: FlTitlesData(
                                leftTitles: SideTitles(reservedSize: 30, showTitles: true, interval: 50 / log(10)),
                                bottomTitles: SideTitles(showTitles: false)),
                            minY: snapshot.data.minPrice,
                            gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (index) {
                                  return FlLine(strokeWidth: 0);
                                }),
                            lineBarsData: [
                              LineChartBarData(
                                spots: snapshot.data.spots,
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
                                  colors: [Colors.lightGreen.withOpacity(0.5)],
                                  cutOffY: 0,
                                  applyCutOffY: true,
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
          )),
    ));
  }
}
