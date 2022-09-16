import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userstudent/screen/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    allusers();
  }

  List data = [];
  Future<void> allusers() async {
    http.Response response = await http.get(
      Uri.parse("https://localhost:44360/api/Auth/allusers"),
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     backgroundColor: Colors.teal,
      //     content: Text("Get All User Successfully")));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     backgroundColor: Colors.teal, content: Text("Something Mising!!!")));
      print("error");
      throw Exception("Failed to load data");
    }
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
    // http.Response response = await http.get(
    //   Uri.parse("https://localhost:44360/api/Auth/logout"),
    // );
    // if (response.statusCode == 200) {
    //   // ScaffoldMessenger.of(context)
    //   //     .showSnackBar(SnackBar(content: Text("LogOut Succesfully")));
    //   Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => LoginPage()));
    // } else {
    //   throw Exception("Error");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // FutureBuilder(builder: ((context, snapshot) {
      //   return Text(
      //       snapshot.hasData ? snapshot.data.toString() : "Loading....");
      // })),
      ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ReusbaleRow(
                    title: 'userId', value: data[index]['userId'].toString()),
                ReusbaleRow(
                    title: 'userName',
                    value: data[index]['userName'].toString()),
              ],
            );
          }),
      Positioned(
        left: 10,
        bottom: 550,
        child: TextButton(
          onPressed: (() {
            logout();
          }),
          child: Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.red),
              child: Center(
                  child: Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))),
        ),
      )
    ]));
  }
}

// ignore: must_be_immutable
class ReusbaleRow extends StatelessWidget {
  String title, value;
  ReusbaleRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
