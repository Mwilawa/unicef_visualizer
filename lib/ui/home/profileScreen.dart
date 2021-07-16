import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_screen/helpers/colors.dart';
import 'package:flutter_login_screen/main.dart';
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/authenticate.dart';
import 'package:flutter_login_screen/ui/widgets/profileWidget.dart';
import 'package:flutter_login_screen/ui/widgets/progressButton.dart';
import 'package:flutter_login_screen/services/helper.dart';

//class ProfileScreen extends StatefulWidget {
//  final User user;
//
//  ProfileScreen({this.user});
//
//  @override
//  State createState() {
//    return _ProfileScreenState(user);
//  }
//}
//
//class _ProfileScreenState extends State<ProfileScreen> {
//  final User user;
//
//  _ProfileScreenState(this.user);
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Container(
//        child: SingleChildScrollView(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              displayCircleImage(user.profilePictureURL, 125, false),
////              AgeGroupCard(),
////              BmiStatusCard(),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(user.firstName),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(user.email),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(user.phoneNumber),
//              ),
//              GestureDetector(
//                onTap: () {
//                  push(context, ConfirmEmail());
//                },
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(user.userID),
//                ),
//              ),
//              ListTile(
//                title: Text(
//                  'Logout',
//                  style: TextStyle(color: Colors.black),
//                ),
//                leading: Transform.rotate(
//                    angle: pi / 1,
//                    child: Icon(Icons.exit_to_app, color: Colors.black)),
//                onTap: () async {
//                  user.active = false;
//                  user.lastOnlineTimestamp = Timestamp.now();
//                  FireStoreUtils.updateCurrentUser(user);
//                  await auth.FirebaseAuth.instance.signOut();
//                  MyAppState.currentUser = null;
//                  pushAndRemoveUntil(context, AuthScreen(), false);
//                },
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}

final _firestore = FirebaseFirestore.instance;
final userEmail = auth.FirebaseAuth.instance.currentUser.email;
//TODO Refactor Code Later

class PersonalInfoStream extends StatefulWidget {
  @override
  _PersonalInfoStreamState createState() => _PersonalInfoStreamState();
}

class _PersonalInfoStreamState extends State<PersonalInfoStream> {
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String gender = '';
  String birthDate = '';
  String documentRef = '';
//  GlobalKey<FormState> _key = new GlobalKey();
  DateTime selectedDate = DateTime.now();
  DateTimeRange dateTimeRange = DateTimeRange(
    start: DateTime(1960),
    end: DateTime(2023),
  );

  Future<void> _selectDate(BuildContext context) async {
    final pickedDates = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
      initialDateRange: dateTimeRange,
    );
    if (pickedDates != null && pickedDates != dateTimeRange)
      setState(() {
        dateTimeRange = pickedDates;
      });
  }

  _updateUser() async {
    showProgress(context, 'Updating User', false);
    auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
    User user = await FireStoreUtils().getCurrentUser(firebaseUser.uid);
    user.firstName = firstName;
    user.lastName = lastName;
    user.phoneNumber = phoneNumber;
    FireStoreUtils.updateCurrentUser(user);
    MyAppState.currentUser = user;
    hideProgress();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .where("email", isEqualTo: userEmail)
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

        final users = snapshot.data.docs;
        List<Widget> personalInfoPages = [
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressButton(
                      width: 110,
                      text: 'Update',
                      textColor: Colors.white,
                      color: kPrimaryColor,
                      onPressed: () {
                        _updateUser();
                      }))),
        ];
        for (var user in users) {
          documentRef = user.reference.id;
          firstName = user.data()['firstName'];
          email = user.data()['email'].toString();
          lastName = user.data()['lastName'].toString();
          phoneNumber = user.data()['phoneNumber'].toString();
          gender = user.data()['gender'].toString();
          birthDate = user.data()['birthDate'];

          final personalInfoPage = PersonalInformationPage(
            firstName: firstName,
            lastName: lastName ?? '',
            phoneNumber: phoneNumber ?? "",
            email: email ?? '',
            birthDate: birthDate ?? "Enter Date",
            gender: gender ?? "Select One",
            onChangedFirstName: (value) {
              firstName = value;
              print(firstName);
            },
            onChangedLastName: (value) {
              lastName = value;
            },
            onChangedEmail: (value) {
              email = value;
            },
            onChangedBirthDate: (value) {
              birthDate = value;
            },
            onChangedGender: (value) {
              gender = value;
            },
            onTapBirthDate: () {
              _selectDate(context);
            },
            onChangedPhoneNumber: (value) {
              phoneNumber = value;
            },
          );

          personalInfoPages.insert(0, personalInfoPage);
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              'Edit personal info',
            ),
            centerTitle: true,
//            leading: IconButton(
//              icon: Icon(
//                Icons.arrow_back,
//              ),
//              onPressed: () async {
//                print(userEmail);
//                print(documentRef);
//                print(FirebaseAuth.instance.currentUser.displayName);
////                updateUser();
//                Navigator.pop(context);
//              },
//            ),
//            actions: [
//              FlatButton(
//                color: Colors.white,
//                child: Text(
//                  "Save",
//                  style: TextStyle(
//                    color: Colors.cyan,
//                  ),
//                ),
//                onPressed: () async {
//                  //TODO Save to FireStore
//                  print(userEmail);
//                  print(documentRef);
////                updateUser();
//                  _firestore
//                      .collection('users')
//                      .doc(documentRef)
//                      .update({
//                        'firstName': firstName,
//                        'lastName': lastName,
//                        'phoneNumber': phoneNumber,
//                        'birthDate': birthDate ?? "",
//                        'email': email,
//                        'gender': gender ?? "",
//                      })
//                      .then((value) => print("User Updated"))
//                      .catchError(
//                          (error) => print("Failed to update user: $error"));
//                  await FirebaseAuth.instance.currentUser.updateProfile(
//                    displayName: firstName,
//                  );
//                  print(FirebaseAuth.instance.currentUser.displayName);
//                  Navigator.pop(context);
//                },
//              )
//            ],
          ),
//          backgroundColor: CupertinoColors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: personalInfoPages,
            ),
          ),
        );
      },
    );
  }
}
