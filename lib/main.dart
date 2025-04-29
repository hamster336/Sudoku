import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    initialRoute: '/',
    routes: {
      '/': (context) => const Home(),
    }
  ));

  // WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
