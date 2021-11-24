import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/ui/screens/login_screen.dart';

class WINDApp extends StatelessWidget {
  late final WINDWebSocketProvider _provider;

  WINDApp({Key? key})
      : _provider = WINDWebSocketProvider(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WIND',
      home: LoginScreen(provider: _provider),
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
