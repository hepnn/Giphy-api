import 'package:flutter/material.dart';
import 'package:giphyfetch/provider/connectivity.dart';
import 'package:giphyfetch/widgets/connectivity_check.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConnectivityCheck(),
    );
  }
}
