import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GenderCard extends StatefulWidget {
  final int MOverweight;
  final int MUnderweight;
  final int MNormal;
  final int MObese;
  final int FOverweight;
  final int FUnderweight;
  final int FNormal;
  final int FObese;

  GenderCard(
      {this.MOverweight,
      this.MUnderweight,
      this.MNormal,
      this.MObese,
      this.FOverweight,
      this.FUnderweight,
      this.FNormal,
      this.FObese});
  @override
  _GenderCardState createState() => _GenderCardState();
}

class _GenderCardState extends State<GenderCard> {
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
                'Gender',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              subtitle: StackedHorizontalBarChart.withSampleData(
                MNormal: widget.MNormal,
                MObese: widget.MObese,
                MOverweight: widget.MOverweight,
                MUnderweight: widget.MUnderweight,
                FNormal: widget.FNormal,
                FObese: widget.FObese,
                FOverweight: widget.FOverweight,
                FUnderweight: widget.FUnderweight,
              )),
        ),
      )),
    );
  }
}

class StackedHorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedHorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory StackedHorizontalBarChart.withSampleData({
    int MOverweight,
    int MUnderweight,
    int MNormal,
    int MObese,
    int FOverweight,
    int FUnderweight,
    int FNormal,
    int FObese,
  }) {
    return new StackedHorizontalBarChart(
      _createSampleData(
        MNormal: MNormal,
        MObese: MObese,
        MOverweight: MOverweight,
        MUnderweight: MUnderweight,
        FNormal: FNormal,
        FObese: FObese,
        FOverweight: FOverweight,
        FUnderweight: FUnderweight,
      ),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData({
    int MOverweight,
    int MUnderweight,
    int MNormal,
    int MObese,
    int FOverweight,
    int FUnderweight,
    int FNormal,
    int FObese,
  }) {
    final underweight = [
      new OrdinalSales(
        'Male',
        MUnderweight,
        charts.Color.fromHex(
          code: "#93B5C6",
        ),
      ),
      new OrdinalSales(
        'Female',
        FUnderweight,
        charts.Color.fromHex(
          code: "#93B5C6",
        ),
      ),
    ];

    final normal = [
      new OrdinalSales(
        'Male',
        MNormal,
        charts.Color.fromHex(
          code: "#006A4E",
        ),
      ),
      new OrdinalSales(
        'Female',
        FNormal,
        charts.Color.fromHex(
          code: "#006A4E",
        ),
      ),
    ];

    final overweight = [
      new OrdinalSales(
        'Male',
        MOverweight,
        charts.Color.fromHex(
          code: "#D7816A",
        ),
      ),
      new OrdinalSales(
        'Female',
        FOverweight,
        charts.Color.fromHex(
          code: "#D7816A",
        ),
      ),
    ];
    final obese = [
      new OrdinalSales(
        'Male',
        MObese,
        charts.Color.fromHex(
          code: "#BD4F6C",
        ),
      ),
      new OrdinalSales(
        'Female',
        FObese,
        charts.Color.fromHex(
          code: "#BD4F6C",
        ),
      ),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Obese',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales sales, _) => sales.color,
        data: obese,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Overweight',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales sales, _) => sales.color,
        data: overweight,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Normal',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales sales, _) => sales.color,
        data: normal,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Underweight',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales sales, _) => sales.color,
        data: underweight,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color color;
  OrdinalSales(this.year, this.sales, this.color);
}
