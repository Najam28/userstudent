import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:userstudent/screen/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> userlogin() async {
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      makeLoginRequest(username.text, password.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal, content: Text("Login Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal,
          content: Text("Enter Valid Username and Password")));
    }
  }

  makeLoginRequest(username, password) async {
    final uri = Uri.parse('https://localhost:44360/api/Auth/login');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Credentials': "true",
      'Access-Control-Allow-Origin': '*'
    };
    Map<String, dynamic> body = {'UserName': username, 'Password': password};
    String jsonBody = json.encode(body);

    final encoding = Encoding.getByName('utf-8');

    await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ).then((http.Response response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      final cookies = response.headers['set-cookie'];
      getTestString();
      print(cookies);
    });

    // int statusCode = response.statusCode;
    // if (statusCode == 200) {
    //   var cookie = response.headers['refreshToken'];
    //   print(cookie);
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.teal, content: Text("Login Successfully")));
    //   Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => HomePage()));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text("Please Enter Invalid Username and Password")));
    // }
    // String responseBody = response.body;
    // print(responseBody);
  }

  final http.Client _client = http.Client();
  Future<String> getTestString() async {
    if (_client is BrowserClient)
      (_client as BrowserClient).withCredentials = true;
    await _client.post(Uri.parse("https://localhost:44360/api/Auth/login"));
    return 'Cookies Generated';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 7),
              child: createtext("Username"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                validator: (value) {
                  return value!.isEmpty ? "Enter Your Username" : null;
                },
                controller: username,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  hintText: "Enter Your Username",
                  labelText: "Username",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 7),
              child: createtext("Password"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? "Enter Your Password" : null;
                  },
                  controller: password,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "Enter Your Password",
                    suffixIcon: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  )),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Login Successfully')),
                      // );
                      userlogin();
                      // requestCookie(username.text, password.text);
                    }
                  },
                  child: Container(
                    height: 70,
                    width: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xffb9C1746)),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText createtext(String richtext) {
    return RichText(
      text: TextSpan(
        text: richtext,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        children: const [
          TextSpan(text: "*", style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }
}


// Map<String, String> headers = {};

  // Future<Map> get(String url) async {
  //   http.Response response = await http.get(url, headers: headers);
  //   updateCookie(response);
  //   return json.decode(response.body);
  // }

  // Future<Map> post(String url, dynamic data) async {
  //   http.Response response = await http.post(url, body: data, headers: headers);
  //   updateCookie(response);
  //   return json.decode(response.body);
  // }

  // void updateCookie(http.Response response) {
  //   String rawCookie = response.headers['set-cookie'] as String;
  //   if (rawCookie != null) {
  //     int index = rawCookie.indexOf(';');
  //     headers['cookie'] =
  //         (index == -1) ? rawCookie : rawCookie.substring(0, index);
  //   }
  // }  