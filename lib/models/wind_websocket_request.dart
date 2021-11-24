import 'package:json_annotation/json_annotation.dart';

part 'wind_websocket_request.g.dart';

@JsonSerializable()
class WINDWebSocketRequest {
  final String type;
  final Map<String, dynamic> payload;

  WINDWebSocketRequest(this.type, this.payload);

  factory WINDWebSocketRequest.fromJson(Map<String, dynamic> json) =>
      _$WINDWebSocketRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WINDWebSocketRequestToJson(this);
}