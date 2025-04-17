import 'package:flutter/material.dart';
import 'LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanzas Personales',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(), // Ahora inicia aquí
    );
  }
}
