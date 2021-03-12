import 'package:flutter/material.dart';
import 'package:unotes/Screens/notes.dart';
import 'package:unotes/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewNotes extends StatefulWidget {
  NewNotes({Key key}) : super(key: key);

  @override
  _NewNotesState createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  bool loading = false;

  TextEditingController notes = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkColor,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: lightColor,
          child: Icon(
            Icons.save,
            color: Colors.white.withOpacity(0.7),
          ),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            if (loading) {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        content: Container(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Saving'),
                              SizedBox(height: 5,),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: lightColor),
                                child: Center(
                                    child: new CircularProgressIndicator()),
                              )
                            ],
                          ),
                        ));
                  });
            }

            var userId = await HelperFunction.getUserId();
            var url = 'https://notesu.herokuapp.com/api/$userId/newNote';
            Map data = {'data': notes.text};
            var body = json.encode(data);
            var response = await http.post(
              url,
              body: body,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            );
            if (response.statusCode == 200) {
              setState(() {
                loading = false;
              });
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Notes()));
            } else {
              setState(() {
                loading = false;
              });
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: Text(
                        'Please try again later',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: darkColor),
                            ))
                      ],
                    );
                  });
            }
          }),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: darkColor,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: TextFormField(
            controller: notes,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
            maxLines: 100,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'You can write your thoughts here',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7))),
          ),
        ),
      ),
    );
  }
}
