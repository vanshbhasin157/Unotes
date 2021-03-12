import 'package:flutter/material.dart';
import 'package:unotes/Auth/login.dart';
import 'package:unotes/Screens/notes.dart';
import 'package:unotes/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   Widget userLoog = CircularProgressIndicator();
    @override
  void initState() {
    userLogin().then((val){
      setState(() {
        userLoog=val;
      });
    });
    super.initState();
  }
  userLogin() async {
    bool isLoggedIn = await HelperFunction.getUserLoggedInSharedPreference();
    if (isLoggedIn == true) {
      return Notes();
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: userLoog);
  }
}
