import 'package:flutter/material.dart';

import 'example2.dart';
import 'example1.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Example2(),
      // home: Example1(),
    );
  }
}

