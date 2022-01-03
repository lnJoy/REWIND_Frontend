import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wind/components/mutual_requests_list.dart';
import 'package:wind/models/wind_mutual_users_model.dart';
import 'package:wind/models/wind_user_model.dart';
import 'package:wind/providers/wind_websocket_provider.dart';
import 'package:wind/utils/shared_pref.dart';

class MutualRequestScreen extends StatefulWidget {
  final WINDWebSocketProvider provider;
  final List<User> mutualRequests;

  const MutualRequestScreen(
      {Key? key, required this.provider, required this.mutualRequests})
      : super(key: key);

  @override
  State<MutualRequestScreen> createState() => _MutualRequestScreenState();
}

class _MutualRequestScreenState extends State<MutualRequestScreen> {
  List<User> _mutualReqeusts = [];

  final TextEditingController _WINDUsernameController = TextEditingController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void didChangeDependencies() {
    getMutualRequests();
    super.didChangeDependencies();
  }

  getMutualRequests() async {
    for (var request in widget.mutualRequests) {
      setState(() {
        _mutualReqeusts.add(request);
      });
    }
  }

  motualRequester(String name) {
    _WINDUsernameController.clear();
    widget.provider.WINDMutualSender(name: name, type: 'request');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    "친구 추가하기",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              controller: _WINDUsernameController,
              onSubmitted: motualRequester,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(8),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFEF7C8E),
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    )),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    "받은 요청",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          _mutualReqeusts.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _mutualReqeusts.length,
                    padding: const EdgeInsets.only(top: 16),
                    itemBuilder: (context, index) {
                      return MutualReqeustList(
                          id: _mutualReqeusts[index].id,
                          name: _mutualReqeusts[index].name,
                          profile: _mutualReqeusts[index].profile,
                          provider: widget.provider);
                    },
                  ),
                )
              : const Expanded(child: Center(child: Text("친구 요청이 없습니다."))),
        ],
    );
  }
}
