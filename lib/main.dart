import 'package:flutter/material.dart';
import "core/routes/app_router.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
        fontFamily: 'Georgia',
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
