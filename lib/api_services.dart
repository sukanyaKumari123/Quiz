import 'dart:convert';

import "package:http/http.dart" as http;

var link =
    "https://opentdb.com/api.php?amount=25&category=11&difficulty=medium&type=multiple";

getQuiz() async {
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = jsonDecode(res.body.toString());
    print("Data is loading");
    return data;
  }
}
