import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'views/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ApiService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT Flutter App',
      home: LoginScreen(),
    );
  }
}