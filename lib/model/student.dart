import 'package:flutter/cupertino.dart';

enum Gender { Male, Female }

@immutable
class Student {
  final String name;
  final int age;
  final String gender;
  final String address;
  final String grade;
  final String bmiStatus;
  final double bmi;

  Student(
      {this.bmiStatus,
      this.bmi,
      this.name,
      this.age,
      this.gender,
      this.grade,
      this.address});

  static List<Student> userList = [
    Student(
        name: 'Jack',
        age: 19,
        gender: "Male",
        address: 'NY',
        bmi: 24.0,
        bmiStatus: 'Normal'),
    Student(name: 'Yang', age: 22, gender: "Male", address: 'CN'),
    Student(name: 'Scarlet', age: 26, gender: "Female", address: 'CA'),
    Student(name: 'Mohan', age: 18, gender: "Male", address: 'DL'),
    Student(name: 'Jack', age: 19, gender: "Male", address: 'LA'),
    Student(name: 'Nany', age: 24, gender: "Female", address: 'DL'),
  ];
}
