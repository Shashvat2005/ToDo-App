import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/theme/theme_provider.dart';
import 'pages/homepage.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open a box
  await Hive.openBox("myBox");

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
