import 'package:flutter/material.dart';
import 'package:userstudent/screen/homepage.dart';
import 'package:userstudent/screen/login.dart';
import 'package:userstudent/screen/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()),
  );
}
