import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/ui/charts/ageGroupCard.dart';
import 'package:flutter_login_screen/ui/charts/bmiStatusCard.dart';
import 'package:flutter_login_screen/ui/charts/dashboardCard.dart';
import 'package:flutter_login_screen/ui/charts/genderCard.dart';

final _firestore = FirebaseFirestore.instance;

class OverviewCards extends StatefulWidget {
  final String schoolName;

  OverviewCards({this.schoolName});

  @override
  _OverviewCardsState createState() => _OverviewCardsState();
}

class _OverviewCardsState extends State<OverviewCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection(widget.schoolName)
            .doc('properties')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final data = snapshot.data;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DashboardCard(
                            title: 'Students',
                            value: data.data()['students'].toString(),
                          ),
                          DashboardCard(
                            title: 'Underweight',
                            value: data.data()['underWeight'].toString(),
                          ),
                          DashboardCard(
                            title: 'Normal',
                            value: data.data()['normal'].toString(),
                          ),
                          DashboardCard(
                            title: 'Overweight',
                            value: data.data()['overWeight'].toString(),
                          ),
                          DashboardCard(
                            title: 'Obese',
                            value: data.data()['obese'].toString(),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
//                        Flexible(child: AgeGroupCard()),
                        BmiStatusCard(
                          normal: data.data()['normal'],
                          obese: data.data()['obese'],
                          underWeight: data.data()['underWeight'],
                          overWeight: data.data()['overWeight'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                  child: AgeGroupCard(
                    nineNormal: data.data()['nineNormal'],
                    nineObese: data.data()['nineObese'],
                    nineOverweight: data.data()['nineOverweight'],
                    nineUnderweight: data.data()['nineUnderweight'],
                    nineteenNormal: data.data()['nineteenNormal'],
                    nineteenObese: data.data()['nineteenObese'],
                    nineteenOverweight: data.data()['nineteenOverweight'],
                    nineteenUnderweight: data.data()['nineteenUnderweight'],
                    fourteenNormal: data.data()['fourteenNormal'],
                    fourteenObese: data.data()['fourteenObese'],
                    fourteenOverweight: data.data()['fourteenOverweight'],
                    fourteenUnderweight: data.data()['fourteenUnderweight'],
                  )),
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
                  child: GenderCard(
                    MNormal: data.data()['MNormal'],
                    MObese: data.data()['MObese'],
                    MOverweight: data.data()['MOverweight'],
                    MUnderweight: data.data()['MUnderweight'],
                    FNormal: data.data()['FNormal'],
                    FObese: data.data()['FObese'],
                    FOverweight: data.data()['FOverweight'],
                    FUnderweight: data.data()['FUnderweight'],
                  ))
            ],
          );
//          return
        },
      ),
    );
  }
}
