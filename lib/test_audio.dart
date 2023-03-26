import 'package:flutter/material.dart';

void main() async {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing Stack"),
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ListView.builder(
            itemCount: 20,
            itemBuilder: (context, int index) {
              return ListTile(
                title: Text('Item at ${index + 1}'),
              );
            },
          ),
          Material(
            elevation: 20.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                // border: Border.all(color: Colors.red, width: 2.0),
                // boxShadow: [
                //   BoxShadow(
                //     // color: Colors.greenAccent.withOpacity(0.5),
                //     color: Colors.greenAccent,
                //     spreadRadius: 7.0,
                //     blurRadius: 17.0,
                //     offset: Offset(0, 3),
                //   ),
                // ],
              ),
              height: 120.0,
              width: double.infinity,
              child: const Center(
                child: Text('Player Controls'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
