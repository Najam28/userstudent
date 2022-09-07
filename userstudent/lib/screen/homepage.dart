import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
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
            // return Table(
            //   children: [
            //     TableRow(children: [Text("User ID"), Text("User Name")])
            //   ],
            // );
          }),
      Positioned(
        left: 1100,
        bottom: 550,
        child: TextButton(
          onPressed: (() {}),
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
        // Container(
        //     height: 60,
        //     width: 400,
        //     decoration:
        //         BoxDecoration(borderRadius: BorderRadius.circular(15)),
        //     child: GestureDetector(child: Text("Logout")))
      ],
    );
  }
}
