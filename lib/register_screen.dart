import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:wind/register_screen.dart';
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
                      inputField(_usernameController, "Username",
                          TextInputType.emailAddress, false),
                      const SizedBox(
                        height: 15,
                      ),
                      inputField(_emailController, "Sunrin Email",
                          TextInputType.emailAddress, false),
                      const SizedBox(
                        height: 15,
                      ),
                      inputField(_passwordController, "Password",
                          TextInputType.visiblePassword, true),
                      const SizedBox(
                        height: 15,
                      ),
                      inputField(_confirmPasswordController, "Confirm Password",
                          TextInputType.visiblePassword, true, pwd: _passwordController.text),
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
    final response = await http.post(Uri.parse(Info().getAPIRegister()),
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
      } else {
        print("${_response['payload']['message']}");
      }
    } else {
      Fluttertoast.showToast(msg: _response['payload']['message']);
    }
  }
}

TextFormField inputField(TextEditingController controller, String hintText,
    TextInputType type, bool isPassword, {String? pwd = "None"}) {
  return TextFormField(
    controller: controller,
    validator: (val) {
      switch(hintText) {
        case "Username": if (val!.isEmpty) return "유저명을 입력해주세요."; break;
        case "Sunrin Email": if (val!.isEmpty) return "이메일을 입력해주세요."; break;
        case "Password": if (val!.isEmpty) return "패스워드를 입력해주세요."; break;
        case "Confirm Password": {
          if (val!.isEmpty) {
            return "패스워드를 입력해주세요.";
          } else if(val != pwd || pwd == "None") {
            return "패스워드가 일치하지 않습니다.";
          }
          break;
        }
      }
    },
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      fillColor: Colors.transparent,
      border: const UnderlineInputBorder(borderSide: BorderSide(width: 1.0, color: Color(0xFFEF7C8E))),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1.0, color: Color(0xFFB6E2D3))),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 1.0, color: Color(0xFFEF7C8E))),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      labelText: hintText,
      labelStyle: const TextStyle(color: Color(0xFFEF7C8E), fontSize: 16),
    ),
    cursorColor: const Color(0xFFEF7C8E),
    keyboardType: type,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
  );
}
