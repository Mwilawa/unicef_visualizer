//import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/helpers/colors.dart';
import 'package:flutter_login_screen/model/food.dart';
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/home/homeScreen.dart';
import 'package:flutter_login_screen/ui/widgets/progressButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

final _firestore = FirebaseFirestore.instance;

class AvailableFoodsScreen extends StatefulWidget {
  final User user;

  AvailableFoodsScreen({this.user});
  @override
  _AvailableFoodsScreenState createState() => _AvailableFoodsScreenState();
}

class _AvailableFoodsScreenState extends State<AvailableFoodsScreen> {
  FoodBrain searchFood = FoodBrain();
  List<String> foods = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addToDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String schoolName = prefs?.getString("schoolName");
//    List<String> newList;
    await _firestore.runTransaction((transaction) async {
      DocumentReference postRef =
          _firestore.collection(schoolName).doc('properties');
      DocumentSnapshot snapshot = await transaction.get(postRef);
      List foodsAvailable = snapshot.data()['foods'] ?? ['None'];
      print(foodsAvailable);
      foodsAvailable.addAll(foods);
      print(foodsAvailable);
      transaction.update(postRef, {'foods': foodsAvailable});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: Text(
                  'What foods are around your school',
                  style: TextStyle(
                      color: Color(COLOR_PRIMARY),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, right: 8.0, left: 8.0),
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            setState(() {
                              foods.add(value);
                            });

//                            FocusScope.of(context).nextFocus();
                          },

//                      onSaved: (String val) {
//                        email = val;
//                      },
                          onTap: () async {
                            final Food result = await showSearch(
                              context: context,
                              delegate: FoodSearch(),
                            );
                            setState(() {
                              foods.add(result.name);
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              fillColor: Colors.white,
                              hintText: 'Search Food',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Color(COLOR_PRIMARY), width: 2.0)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ))))),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: foods != null
//                    ? GridView.builder(
//                        itemCount: foods.length,
//                        gridDelegate:
//                            new SliverGridDelegateWithFixedCrossAxisCount(
//                          crossAxisCount: 2,
//                          childAspectRatio: 1,
//                          crossAxisSpacing: 5,
//                          mainAxisSpacing: 5,
//                        ),
//                        itemBuilder: (BuildContext context, int index) {
//                          print(foods);
//                          return FoodWidget(
//                            food: foods[index],
//                            onPressed: () {
//                              setState(() {
//                                foods.remove(foods[index]);
//                              });
//                            },
//                          );
//                        },
//                      )
//                    : Container(),
                    ? ListView.builder(
                        shrinkWrap: true,
//                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => FoodWidget(
                          food: foods[index],
                          onPressed: () {
                            setState(() {
                              foods.remove(foods[index]);
                            });
                          },
                        ),
//                  ListTile(
//                title: Text((snapshot.data[index] as Food).name),
//                onTap: () {
//                  close(context, snapshot.data[index] as Food);
//                },
//              ),
                        itemCount: foods.length,
                      )
                    : Container(),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressButton(
                    text: 'Finish',
                    textColor: Colors.white,
                    color: kPrimaryColor,
                    onPressed: () {
                      ///TODO Add to Database
//                      SharedPreferences prefs =
//                          await SharedPreferences.getInstance();
//                      String schoolName = prefs?.getString("schoolName");
//
//                      await _firestore.runTransaction((transaction) async {
//                        DocumentReference postRef =
//                            _firestore.collection(schoolName).doc('properties');
//                        DocumentSnapshot snapshot =
//                            await transaction.get(postRef);
//                        List foodsAvailable = snapshot.data()['foods'];
//                        transaction
//                            .update(postRef, {'foods': foodsAvailable + foods});
//                      });
//                      _firestore.collection(schoolName).add({
//                        'foodsAvailable': foods,
//                      });
                      addToDb();
                      pushAndRemoveUntil(
                          context, HomeScreen(user: widget.user), false);
//                  Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FoodWidget extends StatelessWidget {
  final String food;
  final Function onPressed;

  FoodWidget({this.food, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      margin: EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 16.0,
        bottom: 8.0,
      ),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: ListTile(
          title: Text(food,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.white,
                  )),
          trailing: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class FoodSearch extends SearchDelegate<Food> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
          Navigator.pop(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: query == "" ? null : search(query),
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Enter food name'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text((snapshot.data[index] as Food).name),
                    onTap: () {
                      close(context, snapshot.data[index] as Food);
                    },
                  ),
                  itemCount: snapshot.data.length,
                )
              : Container(child: Text('Loading...')),
    );
  }

  bool isReplay = false;
  List filteredList;
  List newList;
  List listOfIndex;

  bool filterSearch(String value, String criteria) {
    return value
        .toString()
        .toLowerCase()
        .trim()
        .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
  }

  Future<List<Food>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    if (search == "empty") return [];
    if (search == "error") throw Error();
    if (search.length > 20) throw Error();

    //Initial List of Foods
    filteredList = Food.foods;
    newList = [];
    listOfIndex = [];
    print(filteredList);

    //Filtering Occurs
    try {
      for (int i = 0; i < filteredList.length; i++) {
        if ((filterSearch(filteredList[i], search) == true)) {
          newList.add(filteredList[i]);
          listOfIndex.add(i);
        }
      }
    } catch (e) {
      print(e);
    }
    print(newList);
    return List.generate(newList.length, (int index) {
      return Food(
        newList[index].toString(),
      );
    });
//    newList = [];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == "" ? null : search(query),
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Enter food name'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text((snapshot.data[index] as Food).name),
                    onTap: () {
                      close(context, snapshot.data[index] as Food);
                    },
                  ),
                  itemCount: snapshot.data.length,
                )
              : Container(child: Text('Loading...')),
    );
  }
}
