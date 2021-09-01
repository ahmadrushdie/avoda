class ChatList {
  List<MyChat> myChats;

  ChatList({this.myChats});

  ChatList.fromJson(Map<String, dynamic> json) {
    if (json['MyChats'] != null) {
      myChats = <MyChat>[];
      json['MyChats'].forEach((v) {
        myChats.add(new MyChat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myChats != null) {
      data['MyChats'] = this.myChats.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyChat {
  String sId;
  With chatWith;

  MyChat({this.sId, this.chatWith});

  MyChat.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chatWith = json['with'] != null ? new With.fromJson(json['with']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.chatWith != null) {
      data['with'] = this.chatWith.toJson();
    }
    return data;
  }
}

class With {
  String userPic;
  String sId;
  String fullName;
  String username;

  With({this.userPic, this.sId, this.fullName, this.username});

  With.fromJson(Map<String, dynamic> json) {
    userPic = json['userPic'];
    sId = json['_id'];
    fullName = json['fullName'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userPic'] = this.userPic;
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['username'] = this.username;
    return data;
  }
}
