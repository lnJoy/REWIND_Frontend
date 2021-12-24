// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wind_websocket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WINDWebSocketResponse _$WINDWebSocketResponseFromJson(Map<String, dynamic> json) =>
    WINDWebSocketResponse(
      json['type'] as String,
      json['payload'] as dynamic,
    );

Map<String, dynamic> _$WINDWebSocketResponseToJson(WINDWebSocketResponse instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
    };