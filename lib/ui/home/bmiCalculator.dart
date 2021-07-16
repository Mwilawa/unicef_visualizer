import 'dart:math';
import 'package:flutter/material.dart';

class CalculatorBrain {
  CalculatorBrain({this.height, this.weight});

  final double height;
  final double weight;

  double _bmi;

  double calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    return double.parse(_bmi.toStringAsFixed(2));
  }

  String getResult() {
    if (_bmi >= 30) {
      return 'Obese';
    } else if (_bmi >= 25 && _bmi < 30) {
      return 'Overweight';
    } else if (_bmi >= 18.5 && _bmi < 25) {
      return 'Normal';
    } else {
      return 'Underweight';
    }
  }

  String getInterpretation() {
    if (_bmi >= 25) {
      return 'You have a higher than normal body weight. Try to exercise more.';
    } else if (_bmi >= 18.5) {
      return 'You have a normal body weight. Good job!';
    } else {
      return 'You have a lower than normal body weight. You can eat a bit more.';
    }
  }

  Color bmiColor() {
    if (_bmi >= 30) {
      return Color(0xffBD4F6C);
    } else if (_bmi >= 25 && _bmi < 30) {
      return Color(0xffD7816A);
    } else if (_bmi >= 18.5 && _bmi < 25) {
      return Color(0xff006A4E);
    } else {
      return Color(0xff93B5C6);
    }
  }
}
