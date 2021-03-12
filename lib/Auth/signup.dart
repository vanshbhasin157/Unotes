import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unotes/Auth/login.dart';

import 'package:unotes/constants.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _name = new TextEditingController();

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
                      controller: _name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Enter Your Name",
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
                                'SignUp',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: new Color(0XFE5e4c35),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                var url =
                                    "https://notesu.herokuapp.com/api/signUp";
                                Map data = {
                                  "name": _name.text,
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
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
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
                                          title: Text(
                                              'This is email is already registered'),
                                          content: Text(
                                            'Try SigningUp with different email address',
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
