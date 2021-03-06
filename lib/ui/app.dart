import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/ui/screens/lobby_screen.dart';
import 'package:wind/ui/screens/login_screen.dart';
import 'package:wind/utils/shared_pref.dart';

class WINDApp extends StatelessWidget {

  const WINDApp({Key? key}) : super(key: key);

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
