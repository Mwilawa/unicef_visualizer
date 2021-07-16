import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/helpers/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

//Returns Reference of object
firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref('/notes.txt');

class AddImage extends StatefulWidget {
//  final Function addImage;
//
//  AddImage({Key key, this.addImage});
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File _image;
//  String _uploadedFileURL;
  File imageURI;
  String path;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadFile(File _image) async {
    firebase_storage.Reference storageReference =
        storage.ref().child('user_profiles/${Path.basename(_image.path)}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => print('File Uploaded'));
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            _image == null
                ? Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      'Update Photo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  )
                : Image.file(_image,
                    width: 299, height: 299, fit: BoxFit.cover),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: 100,
//                  margin: EdgeInsets.fromLTRB(100, 30, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      getImageFromCamera();
                    },
                    child: Container(
                      child: Image(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/images/take_photo.png'),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
//                    margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      getImageFromGallery();
                    },
                    child: Container(
                      child: Image(
                        fit: BoxFit.contain,
                        image:
                            AssetImage('assets/images/upload_from_gallery.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 0, 20),
              child: FlatButton(
                onPressed: () async {
                  String imageURL = await uploadFile(_image);
                  setState(() {
                    FirebaseAuth.instance.currentUser.updateProfile(
                      photoURL: imageURL,
                    );
                  });

                  Navigator.pop(context);
                },
                child: Text('Add Image'),
                textColor: Colors.white,
                color: /*Color(0xFF87e187)*/ kPrimaryColor,
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              ),
            ),
          ])),
    );
  }
}
