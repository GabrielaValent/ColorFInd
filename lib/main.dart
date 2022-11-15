import 'package:flutter/material.dart';
import 'package:testedb2/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Database',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:  const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFFFFAD32),
      ),
      home: const HomePage(),
    );
  }
}