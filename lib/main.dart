import 'package:audio_player/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        /// Creates a uniform splash color when any button or field is clicked or pressed.
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}
