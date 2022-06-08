import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_meteo_app/models/todayMeteo.dart';

Future<Weather> getTodoData() async {
  var url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=London&APPID=a378bd8fe88eb3813ce64bc773f16bf8');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    Weather todaymeteo = Weather();
    return todaymeteo;
  } else {
    print('Request failed : $response.statusCode');
  }
  return Weather();
}
