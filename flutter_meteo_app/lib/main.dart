import 'package:flutter/material.dart';
import 'package:flutter_meteo_app/services/todayMeteo_services.dart';
import 'package:flutter_meteo_app/models/todayMeteo.dart';
import 'package:flutter_meteo_app/models/cities.dart';
import 'package:flutter_meteo_app/databases/cities_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_meteo_app/services/dailyMeteo_services.dart';
import 'models/dailyMeteo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController myController = TextEditingController();
  String searchedCity = "";

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text('Villes enregistrées',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 30),
                  TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ajoutez une ville',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Cities city = Cities(myController.text);
                        DatabaseHelper.instance.addCities(city);
                      });
                    },
                    child: const Text('Ajouter'),
                  ),
                  FutureBuilder<List>(
                    future: DatabaseHelper.instance.getCities(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index].name),
                                trailing: OutlinedButton(
                                  onPressed: () {
                                    DatabaseHelper.instance
                                        .removeCities(snapshot.data![index]);
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Text('une erreur est survenue');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text("il fait beau"),
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
        ),
        body: Container(
            height: 2000,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/rain.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Icon(),
                    _temperature(),
                    _location(),
                    _hourlyPrediction(),
                    _weeklyPrediction(),

                    /*Container(
                      child: FutureBuilder<DailyMeteo>(
                        future: getTodoDataDaily(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.hourly?.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        snapshot.data!.hourly![index].humidity
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold)),
                                    //subtitle: Text(snapshot.data!.description.toString()),
                                  );
                                });
                          } else {
                            return const Center(child: Text("erreur survenue 3"));
                          }
                        },
                      ),
                    )*/
                  ]),
            )));
  }

  final times = ['1', '2', '3', '4', '5', '6', '7', '8'];
  String lat = '';
  String lon = '';

  String _coord() {
    FutureBuilder<Meteo>(
      future: getTodoData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          lat = snapshot.data!.coord!.lat.toString();

          return Center();
        } else {
          return const Center(child: Text("erreur survenue"));
        }
      },
    );
    return lat;
  }

  _coords() {
    FutureBuilder<Meteo>(
      future: getTodoData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          lon = snapshot.data!.coord!.lon.toString();
          return Center();
        } else {
          return const Center(child: Text("erreur survenue"));
        }
      },
    );
    return lon;
  }

  _weeklyPrediction() {
    return Expanded(
        child: Container(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: times.length,
          itemBuilder: (context, index) {
            return Container(
                height: 50,
                child: Card(
                    child: Center(
                  child: FutureBuilder<DailyMeteo>(
                    future: getTodoDataDaily(_coord(), _coords()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: Text(
                          "chargement",
                        ));
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: times.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: 50,
                                  child: Card(
                                      child: Center(
                                          child: Text(
                                              '${snapshot.data!.daily![index].humidity}'))));
                            });
                      } else {
                        return const Center(child: Text("erreur survenue"));
                      }
                    },
                  ),
                )));
          }),
    ));
  }

  _hourlyPrediction() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Colors.white),
        bottom: BorderSide(color: Colors.white),
      )),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: times.length,
          itemBuilder: (context, index) {
            return Container(
                width: 50,
                child: Card(child: Center(child: Text('${times[index]}'))));
          }),
    );
  }

  _Icon() {
    return FutureBuilder<Meteo>(
      future: getTodoData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Text("chargement",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold)));
        } else if (snapshot.connectionState == ConnectionState.done) {
          lat = snapshot.data!.coord!.lat.toString();
          lon = snapshot.data!.coord!.lon.toString();

          return Center(
              child: Column(children: [
            Icon(Icons.cloud, size: 60, color: Colors.white),
            ListTile(
              title: Text(snapshot.data!.weather![0].description.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )),

              //subtitle: Text(snapshot.data!.description.toString()),
            )
          ]));
        } else {
          return const Center(child: Text("erreur survenue"));
        }
      },
    );
  }

  _temperature() {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: Column(children: [
            FutureBuilder<Meteo>(
              future: getTodoData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: ListTile(
                        title: Text(
                      (snapshot.data!.main!.temp! - 273.15).toStringAsFixed(2) +
                          '°C',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w100),
                    )),

                    //subtitle: Text(snapshot.data!.description.toString()),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(child: Text("erreur survenue"));
                } else {
                  return const Center(child: Text(""));
                }
              },
            )
          ]),
        ));
  }

  _location() {
    return FutureBuilder<Meteo>(
      future: getTodoData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Row(children: [
            Icon(Icons.place, color: Colors.white),
            SizedBox(
              width: 5,
            ),
            Flexible(
                child: ListTile(
              title: Text(
                snapshot.data!.name.toString() +
                    ', ' +
                    snapshot.data!.sys!.country.toString(),
                style: TextStyle(color: Colors.white),
              ),

              //subtitle: Text(snapshot.data!.description.toString()),
            ))
          ]);
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Center(child: Text("erreur survenue"));
        } else {
          return const Center(child: Text(""));
        }
      },
    );
  }
}
