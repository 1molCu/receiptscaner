import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/pages.dart';
import '/units/units.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResponseData()),
        ChangeNotifierProvider(create: (_) => AppUpdate())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '票微分',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: MainPage(),
        home: const MainPage(),
        routes: {
          "scaner": (context) => const scanerResult(),
          "setting": (context) => Setting(),
        });
  }
}
