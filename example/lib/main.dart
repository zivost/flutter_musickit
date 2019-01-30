import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:musickit/musickit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Result';

  @override
  void initState() {
    super.initState();
  }

  Future<void> ping() async {
    String ping;
    try {
      ping = await Musickit.ping;
    } on PlatformException {
      ping = 'Failed to get pong.';
    }
    if (!mounted) return;

    setState(() {
      _result = ping;
    });
  }

  Future<void> permission() async {
    String permission;
    try {
      permission = await Musickit.appleMusicRequestPermission;
    } on PlatformException {
      permission = 'Failed to get appleMusic Permission.';
    }
    if (!mounted) return;

    setState(() {
      _result = permission;
    });
  }

  Future<void> playback() async {
    String playback;
    try {
      playback = await Musickit.appleMusicCheckIfDeviceCanPlayback;
    } on PlatformException {
      playback = 'Failed to get appleMusic device playback.';
    }
    if (!mounted) return;

    setState(() {
      _result = playback;
    });
  }

  Future<void> fetchToken() async {
    String fetchToken;
    String developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkFVVENIN0JXNU4ifQ.eyJpYXQiOjE1NDg4NTIyODYsImV4cCI6MTU2NDQwNDI4NiwiaXNzIjoiN0o5OVlBUTVBUSJ9.jNoCPy5ewdnAyIuJmicOfHjWsx_NiFweGrihtHVI7RuMDMMXvqbZoZQGfu5CvY6X-3i_2QUvgM1vFm4sSVl_Og";
    try {
      fetchToken = await Musickit.fetchUserToken(developerToken);
    } on PlatformException {
      fetchToken = 'Failed to get user token.';
    }
    if (!mounted) return;

    setState(() {
      _result = fetchToken;
    });
  }

  Future<void> playTrack() async {
    String track;
    var lst = new List(2); 
    lst[0] = "1307584769"; 
    lst[1] = "770773220";
    // lst[2] = "i.5PkLbQYTz3aAXX";
    try {
      track = await Musickit.appleMusicPlayTrackId(lst);
    } on PlatformException {
      track = 'Failed to play appleMusic track id.';
    }
    if (!mounted) return;

    setState(() {
      _result = track;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MusicKit example app'),
        ),
        body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               new Text(
                '$_result',
                style: new TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Roboto',
                ),
              ),
              new RaisedButton(
                 padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      ping();
                    },
                    child: new Text("Ping"),
              ),
              new RaisedButton(
                 padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      permission();
                    },
                    child: new Text("Request Apple Music Permission"),
              ),
              new RaisedButton(
                 padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      playback();
                    },
                    child: new Text("Check Playback Capability"),
              ),
              new RaisedButton(
                 padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      fetchToken();
                    },
                    child: new Text("Fetch User Token"),
              ),
              new RaisedButton(
                 padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: (){
                      playTrack();
                    },
                    child: new Text("Play Track Id"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

