import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  TextEditingController username = TextEditingController();
  TextEditingController conpassword = TextEditingController();
  TextEditingController email = TextEditingController();
  var countryId;
  String? gender;

  List<String> genders = ["Male", "Female", "Not Preferred"];
  String? isSelected;
  List countries = [];
  String? refToken;
  @override
  void initState() {
    super.initState();
    getAllCountries();
  }

  Future<void> getAllCountries() async {
    http.Response response = await http
        .get(Uri.parse('https://localhost:44360/api/Country'), headers: {
      "Content-Type": "application/json",
      "accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    if (response.statusCode == 200) {
      countries = jsonDecode(response.body);
    } else {
      print("error");
    }
  }

  Future<void> register(username, conpassword, email, gender, countryid) async {
    Map data = {
      'userName': username,
      'password': conpassword,
      'email': email,
      'gender': gender,
      'countryId': countryid,
    };
    print(data);

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
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // String jsonBody = json.encode(response.body);
      // var jsonResponse = json.decode(response.body.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal,
          content: Text("Registration Successfully")));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
      // print(jsonBody);
      //Or put here your next screen using Navigator.push() method
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.teal, content: Text("Not Register")));
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
                  child: createtext("Username"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Username';
                      }
                      return null;
                    },
                    controller: username,
                    keyboardType: TextInputType.emailAddress,
                    decoration: buildInputDecoration(
                        "Enter Your Username", Icons.verified_user_rounded),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 30),
                  child: createtext("Email"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Valid Email Address';
                      }
                      return null;
                    },
                    // validator: (value) {
                    // return validateEmail("Enter Your Email");
                    //   return null;
                    // },
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
                  padding: const EdgeInsets.all(20),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 2, color: Colors.teal))),
                    value: isSelected,
                    hint: Text("Select Gender"),
                    items: genders
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        gender = val as String?;
                      });
                    },
                  ),
                ),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: createtext("Country")),
                // Padding(
                //     padding: const EdgeInsets.only(left: 15, right: 15),
                //     child: TextFormField(
                //       validator: (value) {
                //         return value!.isEmpty ? "Enter Country Name" : null;
                //       },
                //       controller: country,
                //       decoration: buildInputDecoration(
                //           "Country Name", Icons.location_city),
                //     )),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 2, color: Colors.teal))),
                    value: countryId,
                    hint: Text("Select Country"),
                    items: countries
                        .map((e) => DropdownMenuItem(
                            value: e['countryId'],
                            child: Text(e['countryName'])))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        countryId = val;
                        print(val);
                      });
                    },
                  ),
                ),
                Divider(),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: createtext("Confirm Password")),
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter a password';
                          } else if (value.length < 6) {
                            return "Maximum 6 digit password";
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
                          register(username.text, conpassword.text, email.text,
                              gender, countryId);
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
}
