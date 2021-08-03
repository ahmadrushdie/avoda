import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/models/chat_list.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/views/common/rounded_image.dart';

import 'add_chat_view.dart';

class ChatListView extends StatefulWidget {
  ChatListView({Key key}) : super(key: key);

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  List<MyChat> chats;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyChats();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: chats == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                var chat = chats[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddChatPage(
                              reciverId: chat.chatWith.sId, chatId: chat.sId)),
                    );
                  },
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomNetworkImage(
                                width: 50,
                                hieght: 50,
                                isCircular: true,
                                imageUrl: chat.chatWith.userPic),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(chat.chatWith.fullName),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
                );
              }),
    );
  }

  getMyChats() async {
    var response = await NetworkClient.getInstance()
        .request(requestType: RequestType.GET, path: GET_MY_CHATS);

    if (response.statusCode == 200) {
      var chatList = ChatList.fromJson(jsonDecode(response.body));

      setState(() {
        this.chats = chatList.myChats;
      });
    }
  }
}
