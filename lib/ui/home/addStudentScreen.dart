import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/helpers/colors.dart';
import 'package:flutter_login_screen/ui/widgets/progressButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bmiCalculator.dart';

final _firestore = FirebaseFirestore.instance;

enum Gender {
  male,
  female,
}

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  Gender selectedGender;
  String gender;
  bool calculate = false;
  double height = 0;
  double weight = 0;
  int age = 0;
  String name = '';
  String grade = '';
  double bmi = 0.0;
  String bmiStatus = '';

  CalculatorBrain calc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 15.0),
                child: Text(
                  'Add Student',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
//              Container(
//                height: MediaQuery.of(context).size.height * 0.5,
//                width: MediaQuery.of(context).size.width,
//                margin: EdgeInsets.all(10.0),
//                child: GridView.count(
//                  primary: true,
////                padding: EdgeInsets.all(1),
//                  crossAxisSpacing: 10,
//                  mainAxisSpacing: 0,
//                  crossAxisCount: 2,
//                  children: <Widget>[
//                    CustomTextField(
//                      label: 'Full Name',
//                      onChanged: (value) {},
//                    ),
//                    CustomDropDown(
//                      label: 'Male',
//                      list: <String>['Male', 'Female']
//                          .map<DropdownMenuItem<String>>((String value) {
//                        return DropdownMenuItem<String>(
//                          value: value,
//                          child: Text(value),
//                        );
//                      }).toList(),
//                    ),
//                    CustomTextField(
//                      label: 'Age',
//                      onChanged: (value) {},
//                    ),
//                    CustomTextField(
//                      label: 'Weight',
//                      hintText: 'Kg',
//                      onChanged: (value) {
//                        weight = double.parse(value);
//                      },
//                    ),
//                    CustomTextField(
//                      label: 'Height',
//                      hintText: 'cm',
//                      onChanged: (value) {
//                        height = double.parse(value);
//                      },
//                    ),
//                    CustomDropDown(
//                      label: 'Grade 1',
//                      list: ["Grade 1", "Grade 3", "Grade 5", "Grade 7"]
//                          .map<DropdownMenuItem<String>>((String value) {
//                        return DropdownMenuItem<String>(
//                          value: value,
//                          child: Text(value),
//                        );
//                      }).toList(),
//                    ),
//                  ],
//                ),
//              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CustomTextField(
                      label: 'Full Name',
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    CustomDropDown(
                      label: 'Male',
                      onChanged: (value) {
                        gender = value;
                      },
                      list: <String>['Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomTextField(
                          label: 'Age',
                          onChanged: (value) {
                            age = int.parse(value);
                          },
                        ),
                        CustomTextField(
                          label: 'Weight',
                          hintText: 'Kg',
                          onChanged: (value) {
                            weight = double.parse(value);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextField(
                          label: 'Height',
                          hintText: 'cm',
                          onChanged: (value) {
                            height = double.parse(value);
                          },
                        ),
                        CustomDropDown(
                          label: 'Grade 1',
                          onChanged: (value) {
                            grade = value;
                          },
                          list: ["Grade 1", "Grade 5", "Form 1", "Form 3"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              !calculate
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProgressButton(
                          width: 110,
                          text: 'Calculate',
                          textColor: Colors.white,
                          color: kPrimaryColor,
                          onPressed: () {
                            setState(() {
                              calc = CalculatorBrain(
                                height: height,
                                weight: weight,
                              );
                              bmi = calc.calculateBMI();
                              bmiStatus = calc.getResult();
                              calculate = true;
                            });
                          },
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Center(
                          child: Text(
                            'BMI is: $bmi, $bmiStatus',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: calc.bmiColor(),
                                    ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProgressButton(
                              text: 'Add Student',
                              textColor: Colors.white,
                              color: kPrimaryColor,
                              onPressed: () async {
                                ///Add to Database
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String schoolName =
                                    prefs?.getString("schoolName");
                                _firestore
                                    .collection(schoolName)
                                    .doc('properties')
                                    .collection('students')
                                    .add({
                                  'fullName': name,
                                  'age': age,
                                  'weight': weight,
                                  'height': height,
                                  'class': grade,
                                  'BMI': bmi,
                                  'grade': grade,
                                  'gender': gender,
                                  'bmiStatus': bmiStatus,
                                });

                                /// Transaction to change display Values
                                if (bmiStatus == 'Underweight') {
                                  await _firestore
                                      .runTransaction((transaction) async {
                                    DocumentReference postRef = _firestore
                                        .collection(schoolName)
                                        .doc('properties');
                                    DocumentSnapshot snapshot =
                                        await transaction.get(postRef);

                                    ///Update for gender
                                    if (gender == 'Male') {
                                      int MUnderweight =
                                          snapshot.data()['MUnderweight'];
                                      transaction.update(postRef, {
                                        'MUnderweight': MUnderweight + 1,
                                      });
                                    }
                                    if (gender == 'Female') {
                                      int FUnderweight =
                                          snapshot.data()['FUnderweight'];
                                      transaction.update(postRef, {
                                        'FUnderweight': FUnderweight + 1,
                                      });
                                    }

                                    ///Update for Age group
                                    if (age >= 5 && age <= 9) {
                                      int nineUnderweight =
                                          snapshot.data()['nineUnderweight'];
                                      transaction.update(postRef, {
                                        'nineUnderweight': nineUnderweight + 1,
                                      });
                                    } else if (age >= 10 && age <= 14) {
                                      int fourteenUnderweight = snapshot
                                          .data()['fourteenUnderweight'];
                                      transaction.update(postRef, {
                                        'fourteenUnderweight':
                                            fourteenUnderweight + 1,
                                      });
                                    } else if (age >= 14 && age <= 19) {
                                      int nineteenUnderweight = snapshot
                                          .data()['nineteenUnderweight'];
                                      transaction.update(postRef, {
                                        'nineteenUnderweight':
                                            nineteenUnderweight + 1,
                                      });
                                    }

                                    ///Update for general
                                    int students = snapshot.data()['students'];
                                    int value = snapshot.data()['underWeight'];
                                    transaction.update(postRef, {
                                      'underWeight': value + 1,
                                      'students': students + 1,
                                    });
                                  });
                                } else if (bmiStatus == 'Normal') {
                                  await _firestore
                                      .runTransaction((transaction) async {
                                    DocumentReference postRef = _firestore
                                        .collection(schoolName)
                                        .doc('properties');
                                    DocumentSnapshot snapshot =
                                        await transaction.get(postRef);

                                    ///Update for gender
                                    if (gender == 'Male') {
                                      int MNormal = snapshot.data()['MNormal'];
                                      transaction.update(postRef, {
                                        'MNormal': MNormal + 1,
                                      });
                                    }
                                    if (gender == 'Female') {
                                      int FNormal = snapshot.data()['FNormal'];
                                      transaction.update(postRef, {
                                        'FNormal': FNormal + 1,
                                      });
                                    }

                                    ///Update for Age group
                                    if (age >= 5 && age <= 9) {
                                      int nineNormal =
                                          snapshot.data()['nineNormal'];
                                      transaction.update(postRef, {
                                        'nineNormal': nineNormal + 1,
                                      });
                                    } else if (age >= 10 && age <= 14) {
                                      int fourteenNormal =
                                          snapshot.data()['fourteenNormal'];
                                      transaction.update(postRef, {
                                        'fourteenNormal': fourteenNormal + 1,
                                      });
                                    } else if (age >= 14 && age <= 19) {
                                      int nineteenNormal =
                                          snapshot.data()['nineteenNormal'];
                                      transaction.update(postRef, {
                                        'nineteenNormal': nineteenNormal + 1,
                                      });
                                    }
                                    int students = snapshot.data()['students'];
                                    int value = snapshot.data()['normal'];
                                    transaction.update(postRef, {
                                      'normal': value + 1,
                                      'students': students + 1,
                                    });
                                  });
                                } else if (bmiStatus == 'Overweight') {
                                  await _firestore
                                      .runTransaction((transaction) async {
                                    DocumentReference postRef = _firestore
                                        .collection(schoolName)
                                        .doc('properties');
                                    DocumentSnapshot snapshot =
                                        await transaction.get(postRef);

                                    ///Update for gender
                                    if (gender == 'Male') {
                                      int MOverweight =
                                          snapshot.data()['MOverweight'];
                                      transaction.update(postRef, {
                                        'MOverweight': MOverweight + 1,
                                      });
                                    }
                                    if (gender == 'Female') {
                                      int FOverweight =
                                          snapshot.data()['FOverweight'];
                                      transaction.update(postRef, {
                                        'FOverweight': FOverweight + 1,
                                      });
                                    }

                                    ///Update for Age group
                                    if (age >= 5 && age <= 9) {
                                      int nineOverweight =
                                          snapshot.data()['nineOverweight'];
                                      transaction.update(postRef, {
                                        'nineOverweight': nineOverweight + 1,
                                      });
                                    } else if (age >= 10 && age <= 14) {
                                      int fourteenOverweight =
                                          snapshot.data()['fourteenOverweight'];
                                      transaction.update(postRef, {
                                        'fourteenOverweight':
                                            fourteenOverweight + 1,
                                      });
                                    } else if (age >= 14 && age <= 19) {
                                      int nineteenOverweight =
                                          snapshot.data()['nineteenOverweight'];
                                      transaction.update(postRef, {
                                        'nineteenOverweight':
                                            nineteenOverweight + 1,
                                      });
                                    }

                                    ///Update for general
                                    int students = snapshot.data()['students'];
                                    int value = snapshot.data()['overWeight'];
                                    transaction.update(postRef, {
                                      'overWeight': value + 1,
                                      'students': students + 1,
                                    });
                                  });
                                } else {
                                  await _firestore
                                      .runTransaction((transaction) async {
                                    DocumentReference postRef = _firestore
                                        .collection(schoolName)
                                        .doc('properties');
                                    DocumentSnapshot snapshot =
                                        await transaction.get(postRef);

                                    ///Update for gender
                                    if (gender == 'Male') {
                                      int MObese = snapshot.data()['MObese'];
                                      transaction.update(postRef, {
                                        'MObese': MObese + 1,
                                      });
                                    }
                                    if (gender == 'Female') {
                                      int FObese = snapshot.data()['FObese'];
                                      transaction.update(postRef, {
                                        'FObese': FObese + 1,
                                      });
                                    }

                                    ///Update for Age group
                                    if (age >= 5 && age <= 9) {
                                      int nineObese =
                                          snapshot.data()['nineObese'];
                                      transaction.update(postRef, {
                                        'nineObese': nineObese + 1,
                                      });
                                    } else if (age >= 10 && age <= 14) {
                                      int fourteenObese =
                                          snapshot.data()['fourteenObese'];
                                      transaction.update(postRef, {
                                        'fourteenObese': fourteenObese + 1,
                                      });
                                    } else if (age >= 14 && age <= 19) {
                                      int nineteenObese =
                                          snapshot.data()['nineteenObese'];
                                      transaction.update(postRef, {
                                        'nineteenObese': nineteenObese + 1,
                                      });
                                    }

                                    ///Update for general
                                    int students = snapshot.data()['students'];
                                    int value = snapshot.data()['obese'];
                                    transaction.update(postRef, {
                                      'obese': value + 1,
                                      'students': students + 1,
                                    });
                                  });
                                }

                                Navigator.pop(context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class CustomDropDown extends StatefulWidget {
  final String label;
  final Function onChanged;

  final List<DropdownMenuItem<String>> list;

  CustomDropDown({this.label, this.list, this.onChanged});
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _CustomDropDownState extends State<CustomDropDown> {
  String dropdownValue = 'Male';

  @override
  void initState() {
    // TODO: implement initState
    dropdownValue = widget.label ?? 'Grade 1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
//      decoration: BoxDecoration(border: Border.all()),
      padding: EdgeInsets.only(top: 8.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 20,
        elevation: 16,
        style: Theme.of(context).textTheme.bodyText2,
        underline: Container(
          height: 1,
          color: Colors.blue,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            widget.onChanged(newValue);
          });
        },
        items: widget.list ??
            <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hintText;
  final Function onChanged;
  final TextInputType keyboardType;

  CustomTextField(
      {this.icon,
      this.label,
      this.onChanged,
      this.hintText,
      this.keyboardType});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      margin: EdgeInsets.only(right: 16.0),
      child: TextField(
        style: Theme.of(context).textTheme.subtitle2,
        keyboardType: keyboardType ?? TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
//          icon: Icon(icon),
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodyText2,
          hintText: hintText ?? null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: kSecondaryLightColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
        ),
        onChanged: onChanged,
//        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}
