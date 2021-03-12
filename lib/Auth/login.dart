import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unotes/Auth/signup.dart';
import 'package:unotes/Screens/notes.dart';
import 'package:unotes/constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  

  bool isLoading = false;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: new Color(0XFE0d1b21),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/logo.png',
                  scale: 0.5,
                ),
              ),
              Text(
                'unotes',
                style: TextStyle(color: Color(0XFE5e4c35), fontSize: 50),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 50,
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Enter Your Email",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 50,
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Enter Your Password",
                      ),
                    ),
                  ),
                  isLoading == true
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          height: 50,
                          decoration: BoxDecoration(
                              color: lightColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          width: MediaQuery.of(context).size.width,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: darkColor),
                            child:
                                Center(child: new CircularProgressIndicator()),
                          ))
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                              color: new Color(0XFE5e4c35),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                var url =
                                    "https://notesu.herokuapp.com/api/login";
                                Map data = {
                                  "emailAddress": _email.text,
                                  "password": _password.text
                                };
                                var body = json.encode(data);
                                var response = await http.post(
                                  url,
                                  body: body,
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                );
                                if (response.statusCode == 200) {
                                  var resp = json.decode(response.body);
                                  var userId = resp['payload']['id'];
                                  var authToken = resp['token'];
                                  HelperFunction.saveUserId(userId);
                                  HelperFunction.saveAuthToken(authToken);
                                  HelperFunction.saveUserInSharedPreference(
                                      true);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Notes()));
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          title: Text('Invalid Credentials'),
                                          content: Text(
                                            'Please check you email and password and try again',
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                      color: darkColor),
                                                ))
                                          ],
                                        );
                                      });
                                }
                                // _show();
                              }),
                        ),
                  Center(
                      child: Text(
                    'Or',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: RaisedButton(
                      color: lightColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text('SignUp',style: TextStyle(color: Colors.white.withOpacity(0.7)),),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUp()));
                        }),
                  )
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
