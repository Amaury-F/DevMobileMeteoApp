import 'dart:convert';
import 'package:flutter_meteo_app/models/todayMeteo.dart';
import 'package:flutter_meteo_app/services/todayMeteo_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_meteo_app/main.dart';

import '../models/dailyMeteo.dart';

Future<DailyMeteo> getTodoDataDaily() async {
  

  var url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=2.3488&lon=48.8534&exclude={current,minutely,alerts}&appid=a378bd8fe88eb3813ce64bc773f16bf8');
  var response = await http.get(url);
  print(url);
  if (response.statusCode == 200) {
    print(response.body);
    Map jsonResponse = json.decode(response.body);

    DailyMeteo hourlyMeteo = DailyMeteo.fromJson(jsonResponse);

    //Sys todaymeteo = Sys();
    return hourlyMeteo;
  } else {
    print('Request failed : $response.statusCode');
  }
  return DailyMeteo();
}
