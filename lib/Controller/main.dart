import 'package:elephant_client/View/Authentication/sign_in_screen.dart';
import 'package:flutter/material.dart';

import 'app_scroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elephant',
      //theme: ThemeData.light(),
      theme: ThemeData.dark(),
      home: const SignInScreen(),
      scrollBehavior: AppScrollBehavior(),
    );
  }
}
