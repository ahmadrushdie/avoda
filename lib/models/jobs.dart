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
  String field;

  Job({this.createdAt, this.city, this.description, this.sId, this.field});

  Job.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    city = json['city'];
    description = json['description'];
    sId = json['_id'];
    field = json['field'];
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
