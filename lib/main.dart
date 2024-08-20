import 'package:flutter/material.dart';
import 'package:info_cash/app/login_page.dart'; // Импортируйте страницу авторизации
import 'package:info_cash/app/home_copy.dart'; // Импортируйте главную страницу

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Установите страницу авторизации как начальную
    );
  }
}
