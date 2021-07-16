import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AgeGroupCard extends StatefulWidget {
  final int nineOverweight;
  final int nineUnderweight;
  final int nineNormal;
  final int nineObese;
  final int fourteenOverweight;
  final int fourteenUnderweight;
  final int fourteenNormal;
  final int fourteenObese;
  final int nineteenOverweight;
  final int nineteenUnderweight;
  final int nineteenNormal;
  final int nineteenObese;

  AgeGroupCard(
      {this.nineOverweight,
      this.nineUnderweight,
      this.nineNormal,
      this.nineObese,
      this.fourteenOverweight,
      this.fourteenUnderweight,
      this.fourteenNormal,
      this.fourteenObese,
      this.nineteenOverweight,
      this.nineteenUnderweight,
      this.nineteenNormal,
      this.nineteenObese});
  @override
  _AgeGroupCardState createState() => _AgeGroupCardState();
}

class _AgeGroupCardState extends State<AgeGroupCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: 32.0,
          ),
          child: ListTile(
            title: Text(
              'Age groups',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: StackedBarChart.withSampleData(
              nineNormal: widget.nineNormal,
              nineObese: widget.nineObese,
              nineOverweight: widget.nineOverweight,
              nineUnderweight: widget.nineUnderweight,
              nineteenNormal: widget.nineteenNormal,
              nineteenObese: widget.nineteenObese,
              nineteenOverweight: widget.nineteenOverweight,
              nineteenUnderweight: widget.nineteenUnderweight,
              fourteenNormal: widget.fourteenNormal,
              fourteenObese: widget.fourteenObese,
              fourteenOverweight: widget.fourteenOverweight,
              fourteenUnderweight: widget.fourteenUnderweight,
            ),
          ),
        ),
      )),
    );
  }
}

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory StackedBarChart.withSampleData({
    int nineOverweight,
    int nineUnderweight,
    int nineNormal,
    int nineObese,
    int fourteenOverweight,
    int fourteenUnderweight,
    int fourteenNormal,
    int fourteenObese,
    int nineteenOverweight,
    int nineteenUnderweight,
    int nineteenNormal,
    int nineteenObese,
  }) {
    return new StackedBarChart(
      _createSampleData(
        nineNormal: nineNormal,
        nineObese: nineObese,
        nineOverweight: nineOverweight,
        nineUnderweight: nineUnderweight,
        nineteenNormal: nineteenNormal,
        nineteenObese: nineteenObese,
        nineteenOverweight: nineteenOverweight,
        nineteenUnderweight: nineteenUnderweight,
        fourteenNormal: fourteenNormal,
        fourteenObese: fourteenObese,
        fourteenOverweight: fourteenOverweight,
        fourteenUnderweight: fourteenUnderweight,
      ),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
//      primaryMeasureAxis: charts.AxisSpec(showAxisLine: false),
//      domainAxis: charts.AxisSpec(),
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
//      customSeriesRenderers: [],
//      layoutConfig: ,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData({
    int nineOverweight,
    int nineUnderweight,
    int nineNormal,
    int nineObese,
    int fourteenOverweight,
    int fourteenUnderweight,
    int fourteenNormal,
    int fourteenObese,
    int nineteenOverweight,
    int nineteenUnderweight,
    int nineteenNormal,
    int nineteenObese,
  }) {
    final underweightData = [
      new OrdinalSales(
        '5-9',
        nineUnderweight ?? 5,
        charts.Color.fromHex(
          code: "#93B5C6",
        ),
      ),
      new OrdinalSales(
        '10-14',
        fourteenUnderweight ?? 25,
        charts.Color.fromHex(
          code: "#93B5C6",
        ),
      ),
      new OrdinalSales(
        '15-19',
        nineteenUnderweight ?? 100,
        charts.Color.fromHex(
          code: "#93B5C6",
        ),
      ),
//      new OrdinalSales(
//        '15-18',
//        75,
//        charts.Color.fromHex(
//          code: "#93B5C6",
//        ),
//      ),
    ];

    final normalData = [
      new OrdinalSales(
        '5-9',
        nineNormal ?? 25,
        charts.Color.fromHex(
          code: "#006A4E",
        ),
      ),
      new OrdinalSales(
        '10-14',
        fourteenNormal ?? 50,
        charts.Color.fromHex(
          code: "#006A4E",
        ),
      ),
      new OrdinalSales(
        '15-19',
        nineteenNormal ?? 10,
        charts.Color.fromHex(
          code: "#006A4E",
        ),
      ),
//      new OrdinalSales(
//        '15-18',
//        20,
//        charts.Color.fromHex(
//          code: "#006A4E",
//        ),
//      ),
    ];

    final overweightData = [
      new OrdinalSales(
        '5-9',
        nineOverweight ?? 10,
        charts.Color.fromHex(
          code: "#D7816A",
        ),
      ),
      new OrdinalSales(
        '10-14',
        fourteenOverweight ?? 15,
        charts.Color.fromHex(
          code: "#D7816A",
        ),
      ),
      new OrdinalSales(
        '15-19',
        nineteenOverweight ?? 50,
        charts.Color.fromHex(
          code: "#D7816A",
        ),
      ),
//      new OrdinalSales(
//        '15-18',
//        45,
//        charts.Color.fromHex(
//          code: "#D7816A",
//        ),
//      ),
    ];
    final obeseData = [
      new OrdinalSales(
        '5-9',
        nineObese ?? 10,
        charts.Color.fromHex(
          code: "#BD4F6C",
        ),
      ),
      new OrdinalSales(
        '10-14',
        fourteenObese ?? 15,
        charts.Color.fromHex(
          code: "#BD4F6C",
        ),
      ),
      new OrdinalSales(
        '15-19',
        nineteenObese ?? 50,
        charts.Color.fromHex(
          code: "#BD4F6C",
        ),
      ),
//      new OrdinalSales(
//        '15-18',
//        45,
//        charts.Color.fromHex(
//          code: "#BD4F6C",
//        ),
//      ),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Underweight',
        domainFn: (OrdinalSales sales, _) => sales.ageGroup,
        measureFn: (OrdinalSales sales, _) => sales.number,
        data: underweightData,
//        patternColorFn: (OrdinalSales sales, _) => sales.color,
//        fillColorFn: (OrdinalSales sales, _) => sales.color,
        colorFn: (OrdinalSales sales, _) => sales.color,
//        insideLabelStyleAccessorFn:
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Normal',
        domainFn: (OrdinalSales sales, _) => sales.ageGroup,
        measureFn: (OrdinalSales sales, _) => sales.number,
        data: normalData,
        colorFn: (OrdinalSales sales, _) => sales.color,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Overweight',
        domainFn: (OrdinalSales sales, _) => sales.ageGroup,
        measureFn: (OrdinalSales sales, _) => sales.number,
        data: overweightData,
        colorFn: (OrdinalSales sales, _) => sales.color,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Obese',
        domainFn: (OrdinalSales sales, _) => sales.ageGroup,
        measureFn: (OrdinalSales sales, _) => sales.number,
        colorFn: (OrdinalSales sales, _) => sales.color,
        data: obeseData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String ageGroup;
  final int number;
  final charts.Color color;

  OrdinalSales(this.ageGroup, this.number, this.color);
}
