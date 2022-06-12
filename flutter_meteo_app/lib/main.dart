import 'package:flutter/material.dart';
import 'package:flutter_meteo_app/services/todayMeteo_services.dart';
import 'package:flutter_meteo_app/models/todayMeteo.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      
    )]));
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
