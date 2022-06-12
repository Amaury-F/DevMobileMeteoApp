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
                image: AssetImage("assets/images/rain.jpg"), fit: BoxFit.cover),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Paris',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold))
            ],
          ))),
    );
    
     /* appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          children: [
            
            Card(
      child: FutureBuilder<DailyMeteo>(
        future: getTodoDataHourly(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("chargement"));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
               
                    itemCount: snapshot.data!.daily?.length,
                    itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.daily![index].humidity.toString()),
              //subtitle: Text(snapshot.data!.description.toString()),
            );

              });
          } else {
            return const Center(child: Text("erreur survenue"));
          }
        },
      ),
      
    )]));*/
  }
}

// class DaysMeteos extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
        
//         body: FutureBuilder<DailyMeteo>(

//             future: getTodoDataHourly(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: Text("chargement"));
//               } else if (snapshot.connectionState == ConnectionState.done) {
//                 return ListTile(
//                   title: Text(snapshot.data!.daily.toString()),
//                   //subtitle: Text(snapshot.data!.description.toString()),
//                 );
//               } else {
//                 return const Center(child: Text("erreur survenue"));
//               }
//             }
//         ));
            
        
//   }
// }
