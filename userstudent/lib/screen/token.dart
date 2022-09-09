import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';

class CookieToken extends StatefulWidget {
  const CookieToken({super.key});

  @override
  State<CookieToken> createState() => _CookieTokenState();
}

class _CookieTokenState extends State<CookieToken> {
  @override
  void initState() {
    getToken();
    super.initState();
  }

  List data = [];
  Future<void> getToken() async {
    http.Response response = await http.get(
      Uri.parse("https://localhost:44360/api/Auth/refresh-token"),
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
      print(data);
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
      body: Column(
        children: [],
      ),
    );
  }
}
