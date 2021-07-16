import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_screen/model/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/ui/widgets/tableStream.dart';
import 'package:shared_preferences/shared_preferences.dart';

//final _firestore = FirebaseFirestore.instance;

class DataTablesScreen extends StatefulWidget {
  final String schoolName;

  DataTablesScreen(this.schoolName);

  @override
  _DataTablesScreenState createState() => _DataTablesScreenState();
}

class _DataTablesScreenState extends State<DataTablesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Students',
          ),
          centerTitle: true,
        ),
        body: TableStreamBuilder<Student>(
//        stream: Stream.value(students),
//        stream: Data.getStudentStream(widget.schoolName),
          stream: FirebaseFirestore.instance
              .collection(widget.schoolName)
              .doc('properties')
              .collection('students')
              .limit(20)
              .snapshots(),
          headerList: ['Name', 'Age', 'BMI Status'],
          cellValueBuilder: (header, model) {
            switch (header) {
              case 'Name':
                return model.name;
              case 'Age':
                return '${model.age}';
              case 'Gender':
                return '${model.gender}';
              case 'BMI Status':
                return '${model.bmiStatus}';
            }
            return '';
          },
        ));
  }
}

class Data {
  static Stream<List<Student>> getStudentStream(String schoolName) {
    List<Student> stds = [];
    FirebaseFirestore.instance
        .collection(schoolName)
        .doc('properties')
        .collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      final students = querySnapshot.docs;
      for (var student in students) {
        Student std = Student(
          name: student.data()['fullName'],
          age: student.data()['age'],
          gender: student.data()['gender'],
          bmiStatus: student.data()['bmiStatus'],
//          grade: student.data()['grade'],
//          bmi: student.data()['bmi'],
        );
        stds.add(std);
      }
      print(stds);
    });

    return Stream.value(stds);
  }

  static List<Student> getStudentList(String schoolName) {
    List<Student> stds = [];
    FirebaseFirestore.instance
        .collection(schoolName)
        .doc('properties')
        .collection('students')
        .get()
        .then((QuerySnapshot querySnapshot) {
      final students = querySnapshot.docs;
      for (var student in students) {
        Student std = Student(
          name: student.data()['fullName'],
          age: student.data()['age'],
          gender: student.data()['gender'],
          bmiStatus: student.data()['bmiStatus'],
//          grade: student.data()['grade'],
//          bmi: student.data()['bmi'],
        );
        stds.add(std);
      }
      print(stds);
    });
    return stds;
  }
}
