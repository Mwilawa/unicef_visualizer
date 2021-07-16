//import 'dart:html';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_login_screen/model/user.dart';
//import 'package:flutter_login_screen/services/authenticate.dart';
////import 'package:flutter_login_screen/model/user.dart';
////import 'package:flutter_login_screen/services/authenticate.dart';
//import 'package:flutter_login_screen/services/helper.dart';
//import 'package:flutter_login_screen/ui/auth/authScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/authenticate.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:image_picker/image_picker.dart';

//import '../../constants.dart';

//import '../../main.dart';
//
//import '../../main.dart';

File _image;

class PersonalInformationPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String gender;
  final String birthDate;
  final String phoneNumber;
  final String email;
  final Function onChangedFirstName;
  final Function onChangedLastName;
  final Function onChangedGender;
  final Function onChangedBirthDate;
  final Function onChangedPhoneNumber;
  final Function onChangedEmail;
  final Function onTapBirthDate;

  PersonalInformationPage({
    Key key,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.phoneNumber,
    this.email,
    this.onChangedFirstName,
    this.onChangedLastName,
    this.onChangedGender,
    this.onChangedBirthDate,
    this.onChangedPhoneNumber,
    this.onChangedEmail,
    this.onTapBirthDate,
  }) : super(key: key);

  @override
  _PersonalInformationPageState createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
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
            _updatePhoto();
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
            _updatePhoto();
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

  _updatePhoto() async {
    auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
    User user = await FireStoreUtils().getCurrentUser(firebaseUser.uid);
    if (_image != null) {
//      updateProgress('Uploading image, Please wait...');
      showProgress(context, 'Updating image', false);
      user.profilePictureURL = await FireStoreUtils()
          .uploadUserImageToFireStorage(_image, user.userID);
      await firebaseUser.updateProfile(photoURL: user.profilePictureURL);
      await FireStoreUtils.updateCurrentUser(user);
      hideProgress();
      _image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          auth.FirebaseAuth.instance.currentUser.photoURL != null
//          user.profilePictureURL != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: auth.FirebaseAuth.instance.currentUser.photoURL,
                    imageBuilder: (context, imageProvider) => GestureDetector(
                      onTap: () async {
                        _onCameraClick();
//                        _updatePhoto();
//                        auth.User firebaseUser =
//                            auth.FirebaseAuth.instance.currentUser;
//                        User user = await FireStoreUtils()
//                            .getCurrentUser(firebaseUser.uid);
//                        if (_image != null) {
//                          updateProgress('Uploading image, Please wait...');
//                          user.profilePictureURL = await FireStoreUtils()
//                              .uploadUserImageToFireStorage(
//                                  _image, user.userID);
//                          await FireStoreUtils.updateCurrentUser(user);
//                          await firebaseUser.updateProfile(
//                              photoURL: user.profilePictureURL);
//                          await auth.FirebaseAuth.instance.currentUser
//                              .updateProfile(photoURL: user.profilePictureURL);
//                        }
                      },
                      child: Center(
                        child: Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PersonalInfoWidget(
              label: 'First Name',
              hintText:
                  widget.firstName == null ? 'first Name' : widget.firstName,
              onChanged: widget.onChangedFirstName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PersonalInfoWidget(
              label: 'Last Name',
              hintText: widget.lastName,
              onChanged: widget.onChangedLastName,
            ),
          ),
//          GenderWidget(
//            initialGenderValue: gender ?? 'Select One',
//            onChanged: onChangedGender,
//          ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: PersonalInfoWidget(
//              label: 'Birth Date',
//              hintText: birthDate,
//              onChanged: onChangedBirthDate,
//              onTapLabel:
////    () {
//                  onTapBirthDate,
//////                buildDatePicker(context);
////              },
//            ),
//          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PersonalInfoWidget(
              label: 'Email',
              hintText: widget.email,
              onChanged: widget.onChangedEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PersonalInfoWidget(
              label: 'Phone Number',
              hintText: widget.phoneNumber,
              onChanged: widget.onChangedEmail,
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalInfoWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData leading;
  final Function onChanged;
  final Function onTap;
  final Function onTapLabel;
  final bool obscure;
  final TextInputType keyboard;
  final FormFieldValidator validator;
  final TextEditingController controller;
  final FocusNode focusNode;

  PersonalInfoWidget(
      {Key key,
      this.hintText,
      this.leading,
      this.onChanged,
      this.obscure,
      this.keyboard,
      this.validator,
      this.controller,
      this.focusNode,
      this.label,
      this.onTap,
      this.onTapLabel});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: onTapLabel,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          Container(
//            padding: EdgeInsets.all(8.0),
            child: TextFormField(
//              validator: validator,
//              controller: controller,
//              focusNode: focusNode,
              textInputAction: TextInputAction.done,
//              textAlign: TextAlign.left,
              onChanged: onChanged,
              onTap: onTap,
//              keyboardType: keyboard,
//              onTap: () {},
//              onFieldSubmitted: (value) {},
//              autofocus: false,
//              obscureText: obscure ? true : false,
              decoration: InputDecoration(
//                icon: Icon(
//                  leading,
//                  color: Colors.black45 /*Colors.deepPurple*/,
//                ),
                border: InputBorder.none,
                hintText: hintText,
//          hintStyle: TextStyle(
////            fontFamily: 'Poppins',
//              ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GenderWidget extends StatefulWidget {
  final String initialGenderValue;
  final Function onChanged;
  GenderWidget({Key key, @required this.initialGenderValue, this.onChanged})
      : super(key: key);
  @override
  _GenderWidgetState createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  String genderValue = "Select One";

//  String dropdownFilter = 'Short by: Price';
  @override
  void initState() {
    // TODO: implement initState
    genderValue = widget.initialGenderValue ?? "Select One";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          DropdownButton(
            value: genderValue,
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 20.0,
            ),
            underline: Container(),
            onChanged: (value) {
              setState(() {
                genderValue = value;
                widget.onChanged(value);
              });
            },
            items: [
              "Select One",
              "Male",
              "Female",
              "Rather not say",
            ]
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
