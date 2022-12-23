import 'package:flutter/material.dart';

import '/Controller/app_scroll.dart';
import 'Authentication/sign_in_screen.dart';

///Functions in common for all classes in View
class ControllerView {
  start() {
    runApp(const MyApp());
  }
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
