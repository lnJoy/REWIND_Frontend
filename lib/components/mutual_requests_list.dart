import 'package:flutter/material.dart';
import 'package:wind/providers/wind_websocket_provider.dart';

class MutualReqeustList extends StatefulWidget{
  String id;
  String name;
  String? profile;

  final WINDWebSocketProvider provider;

  MutualReqeustList({Key? key, required this.id, required this.name, this.profile, required this.provider}) : super(key: key);
  @override
  _MutualReqeustListState createState() => _MutualReqeustListState();
}

class _MutualReqeustListState extends State<MutualReqeustList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(widget.profile ?? "assets/images/onlyLogo.png"),
                  backgroundColor: Colors.transparent,
                  maxRadius: 30,
                ),
                const SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.name, style: const TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: () {
                    widget.provider.WINDMutualSender(name: widget.name, type: 'response');
                    Navigator.pop(context);
                  },
                  heroTag: 'accept',
                  backgroundColor: const Color(0xFFEF7C8E),
                  splashColor: const Color(0xFFEF7C8E),
                  hoverColor: const Color(0xFFEF7C8E),
                  elevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  disabledElevation: 0,
                  hoverElevation: 0,
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
                FloatingActionButton.small(
                  onPressed: () {
                    widget.provider.WINDMutualSender(name: widget.name, type: 'remove');
                    Navigator.pop(context);
                  },
                  heroTag: 'reject',
                  backgroundColor: Colors.black12,
                  elevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  disabledElevation: 0,
                  hoverElevation: 0,
                  child: const Icon(Icons.close, color: Color(0xFFEF7C8E), size: 30),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}