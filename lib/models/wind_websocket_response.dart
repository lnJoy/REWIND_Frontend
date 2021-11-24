import 'package:json_annotation/json_annotation.dart';

part 'wind_websocket_response.g.dart';

@JsonSerializable()
class WINDWebSocketResponse {
  final String type;
  final Map<String, dynamic> payload;

  WINDWebSocketResponse(this.type, this.payload);

  factory WINDWebSocketResponse.fromJson(Map<String, dynamic> json) =>
      _$WINDWebSocketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WINDWebSocketResponseToJson(this);
}