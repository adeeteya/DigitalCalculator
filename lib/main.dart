import 'package:digital_calculator/constants.dart';
import 'package:digital_calculator/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const DigitalCalculatorApp());
}

class DigitalCalculatorApp extends StatelessWidget {
  const DigitalCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: antiFlashWhite,
        primaryColor: chineseBlue,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: charlestonGreen,
        primaryColor: hanBlue,
      ),
      home: const Home(),
    );
  }
}
