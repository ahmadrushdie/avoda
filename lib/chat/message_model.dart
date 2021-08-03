class MessageList {
  List<Messege> messeges;

  MessageList({this.messeges});

  MessageList.fromJson(Map<String, dynamic> json) {
    if (json['messeges'] != null) {
      messeges = <Messege>[];
      json['messeges'].forEach((v) {
        messeges.add(new Messege.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messeges != null) {
      data['messeges'] = this.messeges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messege {
  String text;
  String senderID;
  String receiverID;
  String createdAt;

  String sId;
  // String sender;
  // String text;
  Messege({this.text, this.senderID, this.receiverID});

  // Message(String text, String senderID, String receiverID) {
  //   this.text = text;
  //   this.senderID = senderID;
  //   this.receiverID = receiverID;
  // }

  Messege.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    sId = json['_id'];
    senderID = json['sender'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['_id'] = this.sId;
    data['sender'] = this.senderID;
    data['text'] = this.text;
    return data;
  }
}

// class Message {
//   final String text;
//   final String senderID;
//   final String receiverID;
//   String createdAt;

//   Message(this.text, this.senderID, this.receiverID);
// }
