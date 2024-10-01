import 'package:eccomerse_app/models/CartModel.dart';
import 'package:eccomerse_app/provider/SearchProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Cart()),
    ChangeNotifierProvider(
        create: (context) => SearchProvider()), // Cart globally accessible
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: SplashScreen());
  }
}
