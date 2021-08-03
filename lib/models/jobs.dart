class Jobs {
  String status;
  int results;
  List<Job> data;

  Jobs({this.status, this.results, this.data});

  Jobs.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    results = json['results'];
    if (json['data'] != null) {
      data = <Job>[];
      json['data'].forEach((v) {
        data.add(new Job.fromJson(v));
      });
    }

    if (json['jobsList'] != null) {
      data = <Job>[];
      json['jobsList'].forEach((v) {
        data.add(new Job.fromJson(v));
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

class Job {
  String createdAt;
  String city;
  String description;
  String sId;
  Field field;
  Owner owner;

  Job(
      {this.createdAt,
      this.city,
      this.description,
      this.sId,
      this.field,
      this.owner});

  Job.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    city = json['city'];
    description = json['description'];
    sId = json['_id'];
    field = Field.fromJson(json['filed']);
    owner = Owner.fromJson(json['owner']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['city'] = this.city;
    data['description'] = this.description;
    data['_id'] = this.sId;
    data['field'] = this.field;
    return data;
  }
}

class Field {
  String id;
  String arabicName;
  String hebrewName;

  String getSpecial(String lang) {
    if (lang == "ar") {
      return arabicName;
    } else {
      return hebrewName;
    }
  }

  Field({this.id, this.arabicName, this.hebrewName});

  Field.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    arabicName = json['ArabicName'];
    hebrewName = json['HebrewName'];
  }
}

class Owner {
  String id;
  String userPic;
  String fullName;

  Owner({this.id, this.userPic, this.fullName});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userPic = json['userPic'];
    fullName = json['fullName'];
  }
}
