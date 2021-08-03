import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/chat/message_model.dart';
import 'package:flutter_app/constants/apis_constants.dart';
import 'package:flutter_app/constants/fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/network/network_client.dart';
import 'package:flutter_app/utils/PrefrenceUtil.dart';
import 'package:flutter_app/views/common/rounded_image.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'chat_bubble.dart';

class AddChatPage extends StatefulWidget {
  AddChatPage({Key key, @required this.reciverId, @required this.chatId})
      : super(key: key);

  String reciverId;
  String chatId;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<AddChatPage> {
  List<Messege> messages = <Messege>[];

  IO.Socket socket;
  User currentUser;
  String message = "";
  bool loadingMessages = true;
  String userId;
  ItemScrollController _scrollController = ItemScrollController();

  final TextEditingController _textController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    init();
    getChatMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Chat")),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        var message = messages[index];
                        return renderMessageRow(message);
                      }),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: 4,
                    minLines: 1,
                    style: TextStyle(fontFamily: KOFI_REGULAR, fontSize: 14),
                    controller: _textController,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "enter_message".tr(),
                      suffixIcon: _textController.text != ""
                          ? IconButton(
                              onPressed: () {
                                sendMessage(
                                    _textController.text, widget.reciverId);
                                setState(() {
                                  _textController.clear();
                                });
                              },
                              icon: Icon(Icons.send),
                            )
                          : null,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            if (loadingMessages) Center(child: CircularProgressIndicator()),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
    socket.dispose();
    socket.close();
    socket = null;
  }

  void init() async {
    currentUser = await PrefrenceUtil.getUser();
    print(currentUser.id);
    userId = currentUser.id;

    // IO.Socket socket = IO.io('http://localhost:3000',
    //   OptionBuilder()
    //       .setTransports(['websocket']) // for Flutter or Dart VM
    //       .setExtraHeaders({'foo': 'bar'}) // optional
    //       .build());

    socket = IO.io(
        'https://avodeem.herokuapp.com',
        OptionBuilder().setTransports(['websocket']).setQuery(
            {'chatID': '${widget.chatId}'}).build());

    socket.onConnect((_) {
      print('connect');
    });

    socket.onConnectError((data) {
      print(data);
    });

    socket.on('receive_message', (jsonData) {
      var data = jsonData;
      messages.add(Messege(
          text: data['content'],
          senderID: data['senderChatID'],
          receiverID: data['receiverChatID']));
      setState(() {
        messages = messages;
      });

      if (messages.length > 1) {
        _scrollController.jumpTo(index: messages.length);
      }
    });
    // socketIO = SocketIOManager().createSocketIO(
    //     'http://avodeem.herokuapp.com', '/',
    //     query: 'chatID=${currentUser.id}');

    // socketIO.init();
    // socketIO.subscribe('receive_message', (jsonData) {
    //   Map<String, dynamic> data = json.decode(jsonData);
    //   messages.add(Message(
    //       data['content'], data['senderChatID'], data['receiverChatID']));
    //   setState(() {
    //     messages = messages;
    //   });
    //   // notifyListeners();
    // });

    // socketIO.connect();
  }

  void sendMessage(String text, String receiverChatID) {
    messages.add(Messege(
        text: text, senderID: currentUser.id, receiverID: receiverChatID));
    socket.emit("send_message", {
      'receiverChatID': receiverChatID,
      'senderChatID': currentUser.id,
      'content': text,
    });

    // socketIO.sendMessage(
    //   'send_message',
    //   json.encode({
    //     'receiverChatID': receiverChatID,
    //     'senderChatID': currentUser.id,
    //     'content': text,
    //   }),
    // );

    setState(() {
      messages = messages;
    });

    if (messages.length > 1) {
      _scrollController.jumpTo(index: messages.length);
    }
  }

  Widget renderMessageRow(Messege message) {
    if (message.senderID == userId) {
      return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
            child: CustomNetworkImage(
              imageUrl: "",
              isCircular: true,
              width: 35,
              hieght: 35,
            ),
          ),
          Expanded(
            child: Wrap(
              children: [
                CustomPaint(
                    painter: CustomChatBubble(isOwn: true),
                    child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          message.text,
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ),
          ),
        ]),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                CustomPaint(
                    painter:
                        CustomChatBubble(isOwn: false, color: Colors.blueGrey),
                    child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          message.text,
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
            child: CustomNetworkImage(
              imageUrl: "",
              isCircular: true,
              width: 35,
              hieght: 35,
            ),
          ),
        ]),
      );

      // return Container(
      //   width: double.infinity,
      //   margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      //   child: Row(
      //       mainAxisAlignment:
      //           MainAxisAlignment.end, //Center Column contents vertically,

      //       children: [
      //         Expanded(
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               CustomPaint(
      //                   painter: CustomChatBubble(
      //                       isOwn: false, color: Colors.blueGrey),
      //                   child: Container(
      //                       padding: EdgeInsets.all(8),
      //                       child: Text(
      //                         message.text,
      //                         style: TextStyle(color: Colors.white),
      //                       ))),
      //             ],
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(left: 8.0, right: 10),
      //           child: CustomNetworkImage(
      //             imageUrl: "",
      //             isCircular: true,
      //             width: 35,
      //             hieght: 35,
      //           ),
      //         ),
      //       ]),
      // );
    }
  }

  getChatMessages() async {
    var response = await NetworkClient.getInstance().request(
        requestType: RequestType.GET, path: GET_CHAT_MESSAGES + widget.chatId);

    if (response.statusCode == 200) {
      var chatList = MessageList.fromJson(jsonDecode(response.body));

      setState(() {
        this.messages = chatList.messeges;
        this.loadingMessages = false;
      });
    }
  }
}
