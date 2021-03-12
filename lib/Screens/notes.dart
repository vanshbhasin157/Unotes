import 'package:flutter/material.dart';
import 'package:unotes/Auth/login.dart';
import 'package:unotes/Screens/editNotes.dart';
import 'package:unotes/Screens/newNote.dart';
import 'package:unotes/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Notes extends StatefulWidget {
  Notes({Key key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  Future<NotesDataList> data;
  @override
  void initState() {
    super.initState();
    Network network = Network(url: 'https://notesu.herokuapp.com/viewNotes');
    data = network.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: lightColor,
          child: Icon(
            Icons.add,
            color: Colors.white.withOpacity(0.7),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewNotes()));
          }),
      body: Container(
        color: darkColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: lightColor, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        onChanged: (value) {
                          FutureBuilder(
                            future: data,
                            builder: (context,
                                AsyncSnapshot<NotesDataList> snapshot) {
                              if (snapshot.hasData) {
                                var notes;
                                for (int i = 0;
                                    i < snapshot.data.notes.length;
                                    i++) {
                                  notes = snapshot.data.notes[i].data;
                                }
                              }
                            },
                          );
                        },
                        decoration: InputDecoration(
                            hintText: 'Search Your Notes',
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7))),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        HelperFunction.signOut();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      })
                ],
              ),
            ),
            FutureBuilder(
                future: data,
                builder: (context, AsyncSnapshot<NotesDataList> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.notes.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, int i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => EditNotes(
                                              text: snapshot.data.notes[i].data,
                                              noteId: snapshot.data.notes[i].id,
                                            )));
                              },
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:BorderRadius.circular(10.0))),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.white54, width: 1.0),
                                        bottom: BorderSide(
                                            color: Colors.white54, width: 1.0),
                                        right: BorderSide(
                                            color: Colors.white54, width: 1.0),
                                        left: BorderSide(
                                            color: Colors.white54, width: 1.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data.notes[i].data,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Theme(
                      data: Theme.of(context).copyWith(accentColor: lightColor),
                      child: Center(child: new CircularProgressIndicator()),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

class NotesDataList {
  final List<NotesData> notes;
  NotesDataList({this.notes});
  factory NotesDataList.fromJson(List<dynamic> parsedJson) {
    List<NotesData> notes = new List<NotesData>();
    notes = parsedJson.map((e) => NotesData.fromJson(e)).toList();
    return new NotesDataList(notes: notes);
  }
}

class NotesData {
  String data;
  String id;
  NotesData({this.data, this.id});
  factory NotesData.fromJson(Map<String, dynamic> json) {
    return NotesData(data: json['data'], id: json['_id']);
  }
}

class Network {
  final String url;
  Network({this.url});
  Future<NotesDataList> loadNotes() async {
    final token = await HelperFunction.getAuthToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res);
      return NotesDataList.fromJson(res);
    } else {
      throw Exception('Err');
    }
  }
}
