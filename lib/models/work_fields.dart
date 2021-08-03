class WorkFields {
  String status;
  int results;
  List<WorkField> data;

  WorkFields({this.status, this.results, this.data});

  WorkFields.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    results = json['results'];
    if (json['data'] != null) {
      data = <WorkField>[];
      json['data'].forEach((v) {
        data.add(new WorkField.fromJson(v));
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

class WorkField {
  String sId;
  String arabicName;
  String hebrewName;
  bool isChecked = false;

  WorkField(
      {this.sId, this.arabicName, this.hebrewName, this.isChecked = false});

  getFieldName(String lang) {
    return lang == "ar" ? arabicName : hebrewName;
  }

  WorkField.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    arabicName = json['ArabicName'];
    hebrewName = json['HebrewName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ArabicName'] = this.arabicName;
    data['HebrewName'] = this.hebrewName;
    return data;
  }
}
