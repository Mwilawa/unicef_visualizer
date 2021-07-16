import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_login_screen/helpers/colors.dart';
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/authenticate.dart';
import 'package:flutter_login_screen/ui/auth/authScreen.dart';
//import 'package:flutter_login_screen/ui/charts/ageGroupCard.dart';
//import 'package:flutter_login_screen/ui/charts/bmiStatusCard.dart';
//import 'package:flutter_login_screen/ui/charts/dashboardCard.dart';
//import 'package:flutter_login_screen/ui/charts/genderCard.dart';
//import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/services/helper.dart';
//import 'package:flutter_login_screen/ui/home/addImage.dart';
import 'package:flutter_login_screen/ui/home/addStudentScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_login_screen/ui/widgets/OverviewCards.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

File _image;

class DashboardScreen extends StatefulWidget {
  final String schoolName;

  DashboardScreen({this.schoolName});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
//  auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
//  User user = await FireStoreUtils().getCurrentUser(firebaseUser.uid);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
//          Color(0xffFEBB00),
          onPressed: () {
            //Go to Add Student Screen
            push(
              context,
              AddStudentPage(),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                    child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          auth.FirebaseAuth.instance.currentUser.photoURL !=
                                  null
                              ? auth.FirebaseAuth.instance.currentUser.photoURL
                              : null,
//                          "https://homepages.cae.wisc.edu/~ece533/images/airplane.png",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
//                          Container(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0, bottom: 8.0, left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.FirebaseAuth.instance.currentUser
                                        .displayName ==
                                    null
                                ? "Name"
                                : auth.FirebaseAuth.instance.currentUser
                                    .displayName
                                    .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: Colors.white),
                          ),
//                          GestureDetector(
//                            onTap: () async {
////                            Navigator.push(
////                                context,
////                                MaterialPageRoute(
////                                    builder: (context) => AddImage()));
//                              setState(() async {
//                                _onCameraClick();
//                                auth.User firebaseUser =
//                                    auth.FirebaseAuth.instance.currentUser;
//                                User user = await FireStoreUtils()
//                                    .getCurrentUser(firebaseUser.uid);
//                                if (_image != null) {
//                                  updateProgress(
//                                      'Uploading image, Please wait...');
//                                  user.profilePictureURL =
//                                      await FireStoreUtils()
//                                          .uploadUserImageToFireStorage(
//                                              _image, user.userID);
//                                  await FireStoreUtils.updateCurrentUser(user);
//                                  await firebaseUser.updateProfile(
//                                      photoURL: user.profilePictureURL);
//                                }
//                              });
//                            },
//                            child: Text(
//                              'Update photo',
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .headline3
//                                  .copyWith(
//                                    color: Colors.blue,
//                                  ),
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Transform.rotate(
                    angle: pi / 1,
                    child: Icon(Icons.exit_to_app, color: Colors.black)),
                onTap: () async {
                  auth.User firebaseUser =
                      auth.FirebaseAuth.instance.currentUser;
                  User user =
                      await FireStoreUtils().getCurrentUser(firebaseUser.uid);
                  user.active = false;
                  user.lastOnlineTimestamp = Timestamp.now();
                  print(user.active);
                  await FireStoreUtils.updateCurrentUser(user);
                  await auth.FirebaseAuth.instance.signOut();
                  MyAppState.currentUser = null;
                  pushAndRemoveUntil(context, AuthScreen(), false);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: OverviewCards(
            schoolName: widget.schoolName,
          ),
//          Column(
//            children: [
//              Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  Container(
//                    margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
//                    width: MediaQuery.of(context).size.width * 0.45,
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        DashboardCard(
//                          title: 'Students',
//                          value: '205k',
//                        ),
//                        DashboardCard(
//                          title: 'Underweight',
//                          value: '100k',
//                        ),
//                        DashboardCard(
//                          title: 'Normal',
//                          value: '75k',
//                        ),
//                        DashboardCard(
//                          title: 'Overweight',
//                          value: '25k',
//                        ),
//                        DashboardCard(
//                          title: 'Obese',
//                          value: '5k',
//                        ),
//                      ],
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
//                    width: MediaQuery.of(context).size.width * 0.5,
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
////                        Flexible(child: AgeGroupCard()),
//                        BmiStatusCard(),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//              Container(
//                  height: MediaQuery.of(context).size.height * 0.4,
//                  width: MediaQuery.of(context).size.width,
//                  margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
//                  child: AgeGroupCard()),
//              Container(
//                  height: MediaQuery.of(context).size.height * 0.4,
//                  width: MediaQuery.of(context).size.width,
//                  margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 4.0),
//                  child: GenderCard())
//            ],
//          ),
        ),
      ),
    );
  }

  final ImagePicker _imagePicker = ImagePicker();

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
