import 'package:flutter/material.dart';
import 'package:trabalho_1/view/login_gui.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {

 sqfliteFfiInit();
 databaseFactory = databaseFactoryFfi;

 runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
