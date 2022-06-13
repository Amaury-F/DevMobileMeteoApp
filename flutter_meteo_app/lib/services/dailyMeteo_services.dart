import 'dart:convert';
import 'package:flutter_meteo_app/models/todayMeteo.dart';
import 'package:http/http.dart' as http;

import '../models/dailyMeteo.dart';

Future<DailyMeteo> getTodoDataDaily() async {
  await Meteo();

  var url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=${Meteo().coord!.lat.toString()}&lon=${Meteo().coord!.lon.toString()}&exclude={current,minutely,alerts}&appid=a378bd8fe88eb3813ce64bc773f16bf8');
  var response = await http.get(url);
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
