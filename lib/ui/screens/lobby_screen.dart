import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wind/components/mutual_list.dart';
import 'package:wind/models/wind_user_model.dart';
import 'package:wind/models/wind_websocket_response.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/ui/screens/login_screen.dart';
import 'package:wind/ui/screens/mutual_requests_screen.dart';
import 'package:wind/utils/shared_pref.dart';

import 'chat_screen.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late final WINDWebSocketProvider provider;
  bool _enableWebSocket = false;
  String data = "No Data";

  List<MutualList> mutualUsers = [];
  List<User> mutualRequests = [];

  Timer? _timer;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // if (!_enableWebSocket) widget.provider.openWIND();
    // setState(() => _enableWebSocket = true);
    initializeDateFormatting('ko_KR', null);

    provider = WINDWebSocketProvider();
    provider.openWIND();
    _timer = Timer.periodic(const Duration(seconds: 40), (timer) {
      setState(() {
        provider.WINDHeartbeatSender();
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider.WINDLoadMutualUsers(type: 'mutual_users');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer!.cancel();
    provider.closeWIND();
    super.dispose();
  }

  logout() async {
    StorageManager.deleteData('token');
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: _onRefresh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "WIND",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MutualRequestScreen(
                                    provider: provider,
                                    mutualRequests: mutualRequests),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.pink[50],
                          ),
                          child: Row(
                            children: const <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.pink,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Add User",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => logout(),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.pink[50],
                          ),
                          child: Row(
                            children: const <Widget>[
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          StreamBuilder<WINDWebSocketResponse>(
            stream: provider.windStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                print('${snapshot.data!.type}: ${JsonEncoder.withIndent(" " * 4).convert(snapshot.data!.payload)}');

                switch (snapshot.data!.type) {
                  case 'error':
                    WINDResponseError(payload: snapshot.data!.payload);
                    break;

                  case 'auth':
                    WINDResponseAuth(payload: snapshot.data!.payload);
                    break;

                  case 'load':
                    WINDResponseLoad(payload: snapshot.data!.payload);
                    break;

                  case 'mutual_users':
                    mutualUsers = [];
                    WINDResponseMutualUsers(payload: snapshot.data!.payload);
                    break;

                  case 'ok':
                    mutualRequests = [];
                    break;

                  default:
                    WINDResponseError(payload: snapshot.data!.payload);
                    break;
                }
              }

              return mutualUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: mutualUsers.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Slidable(
                          // Specify a key if the Slidable is dismissible.
                          key: Key(mutualUsers[index].chatId),

                          // The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  setState(() {
                                    provider.WINDMutualUserDeleter(
                                        name: mutualUsers[index].name);
                                    mutualUsers.removeAt(index);
                                    provider.WINDLoadMutualUsers(
                                        type: 'mutual_users');
                                  });
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),

                          child: MutualList(
                            provider: provider,
                            id: mutualUsers[index].id,
                            name: mutualUsers[index].name,
                            chatId: mutualUsers[index].chatId,
                            messageText: mutualUsers[index].messageText,
                            profile: mutualUsers[index].profile,
                            time: mutualUsers[index].time,
                          ),
                        );
                      },
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[Text("No Friends..")],
                      ),
                    );
            },
          ),
        ],
      ),
    ));
  }

  void WINDResponseError({required dynamic payload}) {
    if (payload['code'] == '4000') {
      logout();
    }
    if (payload['reason'] == "targeted name was not requested.") {
      // 친구 요청이 만료되었을 때 리스트 초기화
      mutualRequests = [];
    }
  }

  void WINDResponseAuth({required dynamic payload}) {
    StorageManager.saveData('user_id', payload['self_user']['id']);

    try {
      for (var mutualUser in json.decode(payload['mutual_users'])) {
        addListMutualUsers(id: mutualUser['id'], name: mutualUser['name']);
      }
      for (var mutualRequest in json.decode(payload['mutual_requests'])) {
        mutualRequests.add(User(
            id: mutualRequest['id'],
            name: mutualRequest['name'],
            profile: mutualRequest['profile']));
      }
    } catch (e) {
      print(e);
    }
  }

  void WINDResponseLoad({required dynamic payload}) {
    print(payload);
  }

  Future<void> WINDResponseMutualUsers({required dynamic payload}) async {
    if (payload is List<dynamic>) {
      for (var mutualUser in payload) {
        addListMutualUsers(id: mutualUser['id'], name: mutualUser['name']);
      }
    } else {
      if (payload['type'] == 'delete') {
      } else {
        // 친구 요청 추가
        mutualRequests = [];
        mutualRequests.add(User(
            id: payload['user']['id'],
            name: payload['user']['name'],
            profile: payload['user']['profile']));
      }
    }
  }

  void addListMutualUsers({required String id, required String name}) async {
    int userId = int.parse(await StorageManager.readData('user_id'));
    String _chatId = (int.parse(id) ^ userId).toString();
    String _datetime = base64.encode(utf8.encode(
        DateFormat('yyyy-M-d HH:mm:ss.S000', 'ko_KR')
            .format(DateTime.now().toUtc().add(const Duration(hours: 9)))));
    String _lastMessage = "";
    String _lastTime = "";
    // provider.WINDLoadChatContents(
    //     chatID: _chatId, datetime: _datetime, count: 1);
    // final subscription = provider.windStream.listen(null);
    // subscription.onData((event) async {
    //   print('ASD: $event');
    //   if (event.type == "chat") {
    //     _lastMessage = await event.payload['content'];
    setState(() {
      mutualUsers.add(MutualList(
          provider: provider,
          id: id,
          chatId: _chatId,
          name: name,
          messageText: _lastMessage,
          time: _lastTime));
    });

    //     subscription.cancel();
    //   }
    // });
  }

  void _onRefresh() {
    setState(() {
      provider.WINDLoadMutualUsers(type: 'mutual_users');
    });
    _refreshController.refreshCompleted();
  }
}
