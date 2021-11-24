import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:wind/utils/shared_pref.dart';

import 'login_screen.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WIND',
      home: const LoginScreen(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark
      ),
    );
  }
}

