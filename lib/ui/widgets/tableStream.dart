import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/model/student.dart';

typedef TableHeaderBuilder = Widget Function(String header);
typedef TableCellBuilder = Widget Function(String cell);
typedef TableCellValueBuilder<Student> = String Function(
    String header, Student value);
typedef HeaderClickHandler = void Function(String header);
typedef RowClickHandler<T> = void Function(T value);

class TableStreamBuilder<T> extends StatelessWidget {
  final List<Student> initialData;
  final List<String> headerList;
  final TableHeaderBuilder headerBuilder;
  final TableCellBuilder cellBuilder;
//  final Stream<List<Student>> stream;
  final Stream<QuerySnapshot> stream;
  final TableCellValueBuilder<Student> cellValueBuilder;
  final HeaderClickHandler headerClickHandler;
  final RowClickHandler<Student> rowClickHandler;

  TableStreamBuilder(
      {this.initialData,
      this.headerBuilder,
      this.cellBuilder,
      this.headerClickHandler,
      this.rowClickHandler,
      @required this.headerList,
      @required this.stream,
      @required this.cellValueBuilder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
//        if (snapshot?.hasData ?? false) return _buildTable(snapshot.data);
        if (snapshot?.hasError ?? false) return Text('Something went wrong!');
//        if (snapshot.hasError) {
//          return Text('Something went wrong');
//        }

//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return Center(
//            child: CircularProgressIndicator(
//              backgroundColor: Colors.lightBlueAccent,
//            ),
//          );
//        }

        if (snapshot?.hasData ?? false) {
          final students = snapshot.data.docs;
          List<Student> stds = [];
          for (var student in students) {
            Student std = Student(
              name: student.data()['fullName'],
              gender: student.data()['gender'],
              grade: student.data()['grade'],
              age: student.data()['age'],
              bmi: student.data()['bmi'],
              bmiStatus: student.data()['bmiStatus'],
            );
            stds.add(std);
          }
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: _getColumns(headerList),
                    rows: _getRows(stds),
                  )));
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ),
        );
      },
    );
  }

  Widget _buildTable(List<Student> data) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: _getColumns(headerList),
              rows: _getRows(data),
            )));
  }

  List<DataColumn> _getColumns(List<String> data) {
    if (headerBuilder != null) {
      return data.map((key) => DataColumn(label: headerBuilder(key))).toList();
    }
    return data
        .map((key) => DataColumn(label: _buildInternelColumnWidget(key)))
        .toList();
  }

  Widget _buildInternelColumnWidget(String column) {
    return Text(column,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  List<DataRow> _getRows(List<Student> data) {
    if (cellBuilder != null) {
      return data
          .map((item) => DataRow(cells: _buildProvidedRowCells(item)))
          .toList();
    }

    return data
        .map((item) => DataRow(cells: _buildInternelRowCells(item)))
        .toList();
  }

  List<DataCell> _buildProvidedRowCells(Student data) {
    return headerList
        .map((header) => DataCell(
              cellBuilder(cellValueBuilder(header, data)),
            ))
        .toList();
  }

  List<DataCell> _buildInternelRowCells(Student data) {
    return headerList
        .map((header) => DataCell(
              _buildInternelRowWidget(cellValueBuilder(header, data)),
            ))
        .toList();
  }

  Widget _buildInternelRowWidget(String row) {
    return Text(
      row,
      style: TextStyle(fontSize: 16),
    );
  }
}
