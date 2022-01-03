import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/ui/screens/lobby_screen.dart';
import 'package:wind/ui/screens/register_screen.dart';
import 'package:wind/utils/info.dart';
import 'package:wind/utils/shared_pref.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => isLogin());
    super.initState();
  }

  isLogin() async {
    String? _token;
    _token = await StorageManager.readData("token");
    if (_token != null) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LobbyScreen()));
    }
  }

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
                      inputField(_emailController, "Sunrin Email",
                          TextInputType.emailAddress, false),
                      const SizedBox(
                        height: 15,
                      ),
                      inputField(_passwordController, "Password",
                          TextInputType.visiblePassword, true),
                      const SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        splashColor: const Color(0x85EF7C8E),
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            Fluttertoast.showToast(msg: "이메일 또는 비밀번호를 입력해주세요.");
                            return;
                          }
                          login(_emailController.text, _passwordController.text);
                          setState(() {
                            isLoading = true;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          child: const Center(
                            child: Text("Login",
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
                      Align(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            onPressed: () {},
                            splashColor: const Color(0xFFEF7C8E),
                            child: const Text("Forgot Password?",
                                style: TextStyle(
                                    color: Color(0xFFEF7C8E),
                                    fontFamily: "NotoSansKR",
                                    fontSize: 15)),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 127),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterScreen()));
                },
                splashColor: const Color(0xFFEF7C8E),
                child: const Text.rich(TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(
                        color: Color(0xFFEF7C8E),
                        fontFamily: "NotoSansKR",
                        fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Sign Up',
                          style: TextStyle(
                              color: Color(0xFFEF7C8E),
                              fontSize: 15,
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.bold)),
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login(email, password) async {
    Map data = {'email': email, 'password': password};
    final response = await http.post(Uri.parse(Info.LOGIN),
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
        print("Token: ${data['token']}");
        StorageManager.saveData('token', data['token']);
        Fluttertoast.showToast(msg: "Login Success!!");
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => const LobbyScreen(),
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

TextFormField inputField(TextEditingController controller, String hintText,
    TextInputType type, bool isPassword) {
  return TextFormField(
    controller: controller,
    validator: (val) {
      switch(hintText) {
        case "Sunrin Email": if (val!.isEmpty) return "이메일을 입력해주세요."; break;
        case "Password": if (val!.isEmpty) return "패스워드를 입력해주세요."; break;
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
