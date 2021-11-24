import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:wind/models/wind_websocket_response.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/utils/shared_pref.dart';

class LobbyScreen extends StatefulWidget {
  final WINDWebSocketProvider provider;

  const LobbyScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {

  late WINDWebSocketProvider _provider;

  late final Stream<WINDWebSocketResponse> stream;
  bool _enableWebSocket = false;
  String data = "No Data";

  @override
  void initState() {
    _provider = WINDWebSocketProvider();
    // if (!_enableWebSocket) widget.provider.openWIND();
    // setState(() => _enableWebSocket = true);
    super.initState();
  }

  @override
  void reassemble() {
    _provider.closeWIND();
    _provider = WINDWebSocketProvider();
    super.reassemble();
  }
  //
  // @override
  // void dispose() {
  //   widget.provider.closeWIND();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<WINDWebSocketResponse>(
            stream: _provider.windStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                return Center(
                  child: Text(
                    '${snapshot.data!.type}: ${JsonEncoder.withIndent(' ' * 4).convert(snapshot.data!.payload)}',
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {

                return const Center(
                  child: Text('No more data'),
                );
              }

              return const Center(
                child: Text('No data'),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: () => _provider.openWIND(), child: Text("Open")),
              ElevatedButton(onPressed: () => _provider = WINDWebSocketProvider(), child: Text("Close")),
            ],
          )
        ],
      )
    );
  }
}
