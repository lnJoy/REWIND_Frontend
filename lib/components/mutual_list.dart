import 'package:flutter/material.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/ui/screens/chat_screen.dart';
import 'package:wind/utils/shared_pref.dart';

class MutualList extends StatefulWidget{
  final WINDWebSocketProvider provider;

  String id;
  String name;
  String chatId;
  String messageText;
  String? profile;
  String time;

  MutualList({Key? key, required this.provider, required this.id, required this.chatId, required this.name, required this.messageText, this.profile, required this.time}) : super(key: key);
  @override
  _MutualListState createState() => _MutualListState();
}

class _MutualListState extends State<MutualList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen(
                provider: widget.provider, name: widget.name, profile: widget.profile, chatID: int.parse(widget.chatId)),
          ),
        );
      },
      child: Container(
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
                          const SizedBox(height: 6,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}