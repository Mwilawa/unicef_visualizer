class Search {
  static bool filterSearch(String value, String criteria) {
    return value
        .toString()
        .toLowerCase()
        .trim()
        .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
  }

  static Future<List<String>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    if (search == "empty") return [];
    if (search == "error") throw Error();
    if (search.length > 20) throw Error();

    //Initial List of Foods
    var filteredList = School.schools;
    var newList = [];
    var listOfIndex = [];
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
      return newList[index].toString();
    });
//    newList = [];
  }
}

class School {
  String name;
  School(this.name);
  static List<String> schools = [
    'Madenge Primary School',
    'St. Joseph Primary School',
    'Mount Everest Primary School',
    'Feza Boys',
    'Ali Muntazr Primary School',
    'Zucha Secondary School',
    "School",
    "Marian",
    "Ilboru (Disabled)",
    "Temeke boys",
    'St.Marys',
  ];
}
