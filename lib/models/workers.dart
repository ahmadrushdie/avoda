class Workers {
  String status;
  int results;
  List<Worker> data;

  Workers({this.status, this.results, this.data});

  Workers.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    results = json['results'];
    if (json['data'] != null) {
      data = <Worker>[];
      json['data'].forEach((v) {
        data.add(new Worker.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['results'] = this.results;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Worker {
  String userPic;
  String lastLogin;
  String sId;
  String fullName;

  Worker({this.userPic, this.lastLogin, this.sId, this.fullName});

  Worker.fromJson(Map<String, dynamic> json) {
    userPic = json['userPic'];
    lastLogin = json['lastLogin'];
    sId = json['_id'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userPic'] = this.userPic;
    data['lastLogin'] = this.lastLogin;
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    return data;
  }
}
