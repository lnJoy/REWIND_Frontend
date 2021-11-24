// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wind_websocket_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WINDWebSocketRequest _$WINDWebSocketRequestFromJson(Map<String, dynamic> json) =>
    WINDWebSocketRequest(
      json['type'] as String,
      json['payload'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$WINDWebSocketRequestToJson(WINDWebSocketRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
    };