import 'package:flutter/material.dart';

import 'view/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quantico'),
      title: "Movie Hub",
      home: HomePage(),
    );
  }
}
