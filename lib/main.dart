import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/report_provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReportProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mis Reportes',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: HomeScreen(),
      ),
    );
  }
}