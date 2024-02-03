import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SimpleChart extends StatelessWidget {
  List<ChartData> listCharts;
  double height;
  double width;
   SimpleChart({required this.listCharts,required this.height,required this.width,super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: SfCircularChart(
            margin: const EdgeInsets.all(0),
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<ChartData, String>(
                opacity: 0.8,
                explode: true,
                explodeIndex: 0,
                explodeOffset: '10%',
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                startAngle: 360,
                endAngle: 360,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                dataSource: listCharts,
                pointColorMapper:(ChartData data, _) => data.color,
              )
            ]
        )
    );
  }
}
class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final int y;
  final Color? color;
}