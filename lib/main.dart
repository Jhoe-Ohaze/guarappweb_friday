import 'package:flutter/material.dart';
import 'package:guarappwebfriday/screens/agreement_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Compra de Ingressos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold
      (
        body: AgreementScreen(),
      ),
    );
  }
}