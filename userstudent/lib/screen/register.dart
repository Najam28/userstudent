import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:userstudent/screen/login.dart';

import '../utils/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController conpassword = TextEditingController();

  Future<void> register(String email, conpassword) async {
    Map data = {
      'userName': email,
      'password': conpassword,
    };
    // print(data);

    String body = json.encode(data);
    var url = Uri.parse('https://localhost:44360/api/Auth/register');
    Response response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    // print(response.body);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      // var jsonResponse = json.decode(response.body.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal,
          content: Text("Registration Successfully")));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
      //Or put here your next screen using Navigator.push() method
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal,
          content: Text("Invalid Email and Password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          "https://images.unsplash.com/photo-1547721064-da6cfb341d50?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                SizedBox(height: 20),
                const Center(
                    child: Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 30),
                  child: createtext("Email"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Valid Email Address';
                      }
                      return null;
                    },
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        buildInputDecoration("Enter Your Email", Icons.email),
                  ),
                ),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: createtext("Gender")),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      addradiobutton(0, "Male"),
                      addradiobutton(1, "Female"),
                      addradiobutton(2, "Not Prefered"),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: createtext("Country")),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      validator: (value) {
                        return value!.isEmpty ? "Enter Country Name" : null;
                      },
                      decoration: buildInputDecoration(
                          "Country Name", Icons.location_city),
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: createtext("Confirm Password")),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'Please Enter Valid Email Address';
                          }
                          return null;
                        },
                        controller: conpassword,
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
                        ))),
                Divider(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //       content: Text('Registration Successfully')),
                          // );
                          register(email.text, conpassword.text);
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
                            "Register",
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
        ),
      ),
    );
  }

  RichText createtext(String richtext) {
    return RichText(
      text: TextSpan(
        text: richtext,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        children: const [
          TextSpan(text: "*", style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }

  List gender = ["Male", "Female", "Others"];
  String? select;
  Row addradiobutton(int btn_value, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<String>(
            value: gender[btn_value],
            groupValue: select,
            onChanged: (value) {
              setState(() {
                select = value as String;
              });
            }),
        Text(title),
      ],
    );
  }
}
