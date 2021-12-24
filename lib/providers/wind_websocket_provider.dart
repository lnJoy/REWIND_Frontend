import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wind/models/wind_websocket_request.dart';
import 'package:wind/models/wind_websocket_response.dart';
import 'package:wind/utils/info.dart';
import 'package:wind/utils/shared_pref.dart';

class WINDWebSocketProvider {
  late final WebSocketChannel _WINDWebSocket;
  final StreamController<dynamic> _WINDWebSocketController = StreamController.broadcast();
  static int heartbeatCount = 0;

  WINDWebSocketProvider() {
    _WINDWebSocket = WebSocketChannel.connect(Uri.parse(Info.WEBSOCKET));
    _WINDWebSocketController.addStream(_WINDWebSocket.stream);
  }

  @visibleForTesting
  WINDWebSocketProvider.testing(this._WINDWebSocket);

  Stream<WINDWebSocketResponse> get windStream => _WINDWebSocketController.stream
      .map<WINDWebSocketResponse>(
        (value) => WINDWebSocketResponse.fromJson(jsonDecode(value)));

  void openWIND() async {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
            'heartbeat',
            {
              'count': heartbeatCount,
            }
        ).toJson(),
      ),
    );
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

  void WINDHeartbeatSender() async {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
          'heartbeat',
          {
            'count': heartbeatCount++
          }
        ).toJson(),
      ),
    );
  }

  void WINDMessageSender(int chatID, String content) async {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
            'chat',
            {
              'type': "send",
              'chat_id': chatID.toString(),
              'content': content
            }
        ).toJson(),
      ),
    );
  }

  void WINDMutualSender({ required String name, required String type }) {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
            'mutual_users',
            {
              'type': type, // response or remove
              'name': name
            }
        ).toJson(),
      ),
    );
  }

  void WINDLoadMutualUsers({required type}) {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
            'load',
            {
              'type': type, // response or remove
            }
        ).toJson(),
      ),
    );
  }

  Future<void> WINDLoadChatContents({required String chatID, required String datetime, int count = 50}) async {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
            'load',
            {
              'type': 'chat',
              'load_id': chatID,
              'datetime': datetime,
              'count': count
            }
        ).toJson(),
      ),
    );
  }

  void WINDMutualUserDeleter({required String name}) async {
    _WINDWebSocket.sink.add(
      jsonEncode(
        WINDWebSocketRequest(
            'mutual_users',
            {
              'type': 'delete',
              'name': name,
            }
        ).toJson(),
      ),
    );
  }
}