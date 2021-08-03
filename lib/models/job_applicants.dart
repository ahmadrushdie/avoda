class JobApplicants {
  List<Applicant> data;

  JobApplicants({this.data});

  JobApplicants.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Applicant>[];
      json['data'].forEach((v) {
        data.add(new Applicant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Applicant {
  Null userPic;
  String sId;
  String fullName;

  Applicant({this.userPic, this.sId, this.fullName});

  Applicant.fromJson(Map<String, dynamic> json) {
    userPic = json['userPic'];
    sId = json['_id'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userPic'] = this.userPic;
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    return data;
  }
}
