import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wind/models/wind_websocket_request.dart';
import 'package:wind/models/wind_websocket_response.dart';
import 'package:wind/utils/info.dart';
import 'package:wind/utils/shared_pref.dart';

class WINDWebSocketProvider {
  late final WebSocketChannel _WINDWebSocket;

  WINDWebSocketProvider()
      : _WINDWebSocket = WebSocketChannel.connect(Uri.parse(Info.WEBSOCKET));

  @visibleForTesting
  WINDWebSocketProvider.testing(this._WINDWebSocket);

  Stream<WINDWebSocketResponse> get windStream => _WINDWebSocket.stream
      .map<WINDWebSocketResponse>(
        (value) => WINDWebSocketResponse.fromJson(jsonDecode(value)));

  void openWIND() async {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
          'auth',
          {
            'auth': await StorageManager.readData('token'),
          }
        ).toJson(),
      ),
    );
  }

  void closeWIND() {
    _WINDWebSocket.sink.close();
  }
}