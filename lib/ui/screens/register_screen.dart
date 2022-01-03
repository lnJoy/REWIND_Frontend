import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/ui/screens/login_screen.dart';
import 'package:wind/ui/screens/register_screen.dart';
import 'package:wind/utils/info.dart';
import 'package:wind/utils/shared_pref.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 45.5),
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/Small_WIND.png'),
              ),
              const SizedBox(height: 38.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("WIND",
                            style: TextStyle(
                                color: Color(0xFFEF7C8E),
                                fontFamily: "NotoSansKR",
                                fontWeight: FontWeight.w900,
                                fontSize: 35)),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        cursorColor: const Color(0xFFEF7C8E),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: inputDecoration("Username"),
                        validator: (val) {
                          if (val!.isEmpty) return "유저명을 입력해주세요.";
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: const Color(0xFFEF7C8E),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: inputDecoration("Sunrin Email"),
                        validator: (val) {
                          if (val!.isEmpty) return "이메일을 입력해주세요.";
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: const Color(0xFFEF7C8E),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: inputDecoration("Password"),
                        validator: (val) {
                          if (val!.isEmpty) return "비밀번호를 입력해주세요.";
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        cursorColor: const Color(0xFFEF7C8E),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: inputDecoration("Confirm Password"),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "비밀번호를 입력해주세요.";
                          } else {
                            if (val != _passwordController.text) {
                              return "비밀번호가 일치하지 않습니다.";
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        splashColor: const Color(0x85EF7C8E),
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            Fluttertoast.showToast(msg: "제대로 입력해주세요.");
                            return;
                          }
                          // _formKey.currentState!.validate();
                          register(_usernameController.text, _emailController.text, _passwordController.text);
                          setState(() {
                            isLoading = true;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          child: const Center(
                            child: Text("Register",
                                style: TextStyle(
                                    color: Color(0xFFEF7C8E),
                                    fontFamily: "NotoSansKR",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25)),
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                  width: 1.0, color: Color(0xFFEF7C8E)),
                              bottom: BorderSide(
                                  width: 1.0, color: Color(0xFFEF7C8E)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  register(username, email, password) async {
    Map data = {'name': username, 'email': email, 'password': password};
    final response = await http.post(Uri.parse(Info.REGISTER),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      isLoading = false;
    });

    Map<String, dynamic> _response = jsonDecode(response.body);
    if (response.statusCode == 201) {
      if (_response['error'] == null) {
        Map<String, dynamic> data = _response['payload'];
        print("Message: ${data['message']}");
        Fluttertoast.showToast(msg: "Register Success!!");
        Navigator.of(context).pop(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      } else {
        print("${_response['payload']['message']}");
      }
    } else {
      Fluttertoast.showToast(msg: _response['payload']['message']);
    }
  }
}

InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
    fillColor: Colors.transparent,
    border: const UnderlineInputBorder(borderSide: BorderSide(width: 1.0, color: Color(0xFFEF7C8E))),
    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1.0, color: Color(0xFFB6E2D3))),
    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1.0, color: Color(0xFFEF7C8E))),
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
    labelText: hintText,
    labelStyle: const TextStyle(color: Color(0xFFEF7C8E), fontSize: 16),
  );
}