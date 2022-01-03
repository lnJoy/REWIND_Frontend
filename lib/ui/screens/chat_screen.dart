import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wind/models/wind_message_model.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/utils/shared_pref.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatScreen extends StatefulWidget {
  final int chatID;
  final String name;
  final String? profile;
  final WINDWebSocketProvider provider;

  const ChatScreen(
      {Key? key,
      required this.provider,
      required this.name,
      this.profile,
      required this.chatID})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<MessageItem> _items = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  StreamSubscription? subscription;
  // subscription.onData((event) async {
  //   print('ASD: $event');
  //   if (event.type == "chat") {
  //     _lastMessage = await event.payload['content'];

  @override
  void initState() {
    subscription = widget.provider.windStream.listen(null);
    subscription!.onData((data) async {
      if (data.type == "chat") {
        print(data);
        MessageManager(await data.payload);
      }
    });
    String _datetime = base64.encode(utf8.encode(
        DateFormat('yyyy-M-d HH:mm:ss.S000', 'ko_KR')
            .format(DateTime.now().toUtc().add(const Duration(hours: 9)))));
    widget.provider.WINDLoadChatContents(
        chatID: widget.chatID.toString(), datetime: _datetime, count: 50);
    super.initState();
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(
                      widget.profile ?? "assets/images/onlyLogo.png"),
                  backgroundColor: Colors.transparent,
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              // onRefresh: _onRefresh,
              // onLoading: _onLoading,
              // enablePullDown: false,
              // enablePullUp: true,
              child: ListView.builder(
                itemCount: _items.length,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const AlwaysScrollableScrollPhysics(),
                reverse: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (_items[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (_items[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : const Color(0x64EF7C8E)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _items[index].messageContent,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _handlerSubmitted,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () => _handlerSubmitted(_controller.text),
                    child: Image.asset(
                      "assets/images/Small_WIND.png",
                      color: Colors.white,
                      width: 22,
                    ),
                    backgroundColor: const Color(0xFFEF7C8E),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void MessageManager(Map<String, dynamic> payload) async {
    String userId = await StorageManager.readData('user_id');
    String _messageType = payload['user_id'] == userId ? "sender" : "receiver";
    if (mounted) {
      setState(() {
        // if (_items.isNotEmpty) {
        //   if(DateTime.parse(payload['created_at']).compareTo(DateTime.parse(_items.last.messageCreatedAt.toString())) < 0) {
        //     _items.add(MessageItem(
        //         chatid: int.parse(payload['chat_id']),
        //         messageType: _messageType,
        //         messageContent: payload['content'],
        //         messageCreatedAt: payload['created_at']));
        //   }else {
        //     for(var i = 0; i < _items.length - 1; i++) {
        //       if(DateTime.parse(_items.toList().elementAt(i).messageCreatedAt).millisecondsSinceEpoch < DateTime.parse(payload['created_at']).millisecondsSinceEpoch &&
        //           DateTime.parse(payload['created_at']).millisecondsSinceEpoch < DateTime.parse(_items.toList().elementAt(i + 1).messageCreatedAt).millisecondsSinceEpoch) {
        //         _items.insert(i, MessageItem(
        //             chatid: int.parse(payload['chat_id']),
        //             messageType: _messageType,
        //             messageContent: payload['content'],
        //             messageCreatedAt: payload['created_at']));
        //         return;
        //       }
        //     }
        //   }
        // }
          _items.insert(0, MessageItem(
              chatid: int.parse(payload['chat_id']),
              messageType: _messageType,
              messageContent: payload['content'],
              messageCreatedAt: payload['created_at']));
      });
    }
  }

  void _handlerSubmitted(String text) {
    _controller.clear();
    setState(() {
      widget.provider.WINDMessageSender(widget.chatID, text);
    });
  }

  // void _onRefresh() {
  //   String _datetime = base64.encode(utf8.encode(_items.last.messageCreatedAt.toString()));
  //   // print('Last : ${base64.encode(utf8.encode(_items.last.messageCreatedAt.toString()))}');
  //   // print('First : ${base64.encode(utf8.encode(_items.first.messageCreatedAt.toString()))}');
  //   widget.provider.WINDLoadChatContents(
  //       chatID: widget.chatID.toString(), datetime: _datetime, count: 10);
  //   _refreshController.refreshCompleted();
  // }
  //
  // void _onLoading() {
  //   String _datetime = base64.encode(utf8.encode(_items.last.messageCreatedAt.toString()));
  //   // print('Last : ${base64.encode(utf8.encode(_items.last.messageCreatedAt.toString()))}');
  //   // print('First : ${base64.encode(utf8.encode(_items.first.messageCreatedAt.toString()))}');
  //   widget.provider.WINDLoadChatContents(
  //       chatID: widget.chatID.toString(), datetime: _datetime, count: 10);
  //   _refreshController.loadComplete();
  // }
}
