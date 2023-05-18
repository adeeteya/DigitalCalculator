import 'package:digital_calculator/constants.dart';
import 'package:digital_calculator/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
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
      theme: ThemeData(scaffoldBackgroundColor: antiFlashWhite),
      darkTheme: ThemeData(scaffoldBackgroundColor: charlestonGreen),
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}
