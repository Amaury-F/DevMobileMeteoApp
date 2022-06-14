import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_meteo_app/models/todayMeteo.dart';

Future<Meteo> getTodoData(String city) async {
  var url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=a378bd8fe88eb3813ce64bc773f16bf8');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    //print(response.body);
    Map jsonResponse = json.decode(response.body);

    Meteo myMeteo = Meteo.fromJson(jsonResponse);

    //Sys todaymeteo = Sys();
    return myMeteo;
  } else {
    print('Request failed : $response.statusCode');
  }
  return Meteo();
}
