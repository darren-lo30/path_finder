import 'package:flutter/material.dart';
import 'package:walk_finder/path_finder.dart';
import 'package:flutter_config/flutter_config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "PathFinder",
        theme: ThemeData(
          fontFamily: 'Raleway',
        ),
        home: const PathFinder());
  }
}
