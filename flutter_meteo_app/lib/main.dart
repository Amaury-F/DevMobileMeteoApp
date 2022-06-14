import 'package:flutter/material.dart';
import 'package:flutter_meteo_app/models/cities.dart';
import 'package:flutter_meteo_app/databases/cities_db.dart';
import 'package:sqflite/sqflite.dart';

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
  String searchedCity = "London";

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
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ajoutez une ville',
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Cities city = Cities(myController.text);
                      DatabaseHelper.instance.addCities(city);
                      myController.clear();
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
                              onTap: () {
                                setState(() {
                                  searchedCity = snapshot.data![index].name;
                                });
                                Navigator.pop(context);
                              },
                              title: Text(snapshot.data![index].name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              trailing: OutlinedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                                onPressed: () {
                                  setState(() {
                                    DatabaseHelper.instance
                                        .removeCities(snapshot.data![index]);
                                  });
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
            children: [
              Text("$searchedCity",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold))
            ],
          ))),
    );
  }
}
