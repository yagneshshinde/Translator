import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

const YELLOW = Color(0xfffbed96);
const BLUE = Color(0xffabecd6);
const BLUE_DEEP = Color(0xffA8CBFD);
const BLUE_LIGHT = Color(0xffAED3EA);
const PURPLE = Color(0xffccc3fc);
const RED = Color(0xffF2A7B3);
const GREEN = Color(0xffc7e5b4);
const RED_LIGHT = Color(0xffFFC3A0);
const TEXT_BLACK = Color(0xFF353535);
const TEXT_BLACK_LIGHT = Color(0xFF34323D);
const TRANSLATE_TEXT = "Translate Text";
String name = "";

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  final Future<String> post;

  SampleApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    MaterialApp materialApp = MaterialApp(
      title: "MyApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.lightGreen),
      home: SampleAppPage(post),
    );
    return materialApp;
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage(Future<String> post);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    SampleAppPageState _sampleAppPageState = SampleAppPageState();

    return _sampleAppPageState;
  }
}

class SampleAppPageState extends State<SampleAppPage> {
  String textToTranslate = "I Like Flutter";
  String textToShow = "I Like Flutter";
  String language = "HI";

  final myController = TextEditingController();

  void updateText() {
//    setState(() {
    fetchTransPost(textToTranslate, name);
//      textToShow = myController.text;
//    });
  }

  _onSubmitted(String value) {
//    setState(() {
    textToTranslate = value;
//    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  DropdownButton _hintDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "HI",
            child: Text(
              "Hindi",
            ),
          ),
          DropdownMenuItem<String>(
            value: "MR",
            child: Text(
              "Marathi",
            ),
          ),
          DropdownMenuItem<String>(
            value: "FR",
            child: Text(
              "French",
            ),
          ),
          DropdownMenuItem<String>(
            value: "AR",
            child: Text(
              "Urdu",
            ),
          ),
        ],
        onChanged: (value) {
          print("value: $value");

          setState(() {
            name = value;
          });
        },
        hint: Text(
          "Please select language",
          style: TextStyle(
            color: TEXT_BLACK,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Translator"),
      ),
      body: Center(
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Please enter a text'),
                controller: myController,
//                onSubmitted: _onSubmitted,
                onChanged: _onSubmitted,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: YELLOW,
                child: _hintDown(),
              ),
              RaisedButton(
                onPressed: updateText,
                child: Text("Translate"),
              ),
              Text(
                textToShow,
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void changedDropDownItem(String selectedLanguage) {}

  Future<String> fetchTransPost(String text, String language) async {
    final response = await http.get(
        'https://translation.googleapis.com/language/translate/v2?target=' +
            language +
            '&key=' +
            text);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      var result = json.decode(response.body);
      var data = result['data'];
      var translations = data['translations'];
      String myText;
      for (var trans in translations) {
        myText = trans['translatedText'].toString();
      }

      setState(() {
        textToShow = myText;
      });
      return myText;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
