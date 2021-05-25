class Profile {
  String status;
  Data data;

  Profile({this.status, this.data});

  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String userPic;
  String lastLogin;
  int refeN;
  String city;
  String country;
  bool workStatus;
  List<String> languages;
  List<Null> workFields;
  String bio;
  String sId;
  String username;
  String fullName;
  String userType;
  ProfilePhotos profilePhotos;
  UsersReference usersReference;
  int iV;

  Data(
      {this.userPic,
      this.lastLogin,
      this.refeN,
      this.city,
      this.country,
      this.workStatus,
      this.languages,
      this.workFields,
      this.bio,
      this.sId,
      this.username,
      this.fullName,
      this.userType,
      this.profilePhotos,
      this.usersReference,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    userPic = json['userPic'];
    lastLogin = json['lastLogin'];
    refeN = json['refeN'];
    city = json['city'];
    country = json['country'];
    workStatus = json['workStatus'];
    languages = json['languages'].cast<String>();
    if (json['workFields'] != null) {
      // workFields = new List<Null>();
      // json['workFields'].forEach((v) {
      //   workFields.add(new Null.fromJson(v));
      // });
    }
    bio = json['bio'];
    sId = json['_id'];
    username = json['username'];
    fullName = json['fullName'];
    userType = json['userType'];
    profilePhotos = json['ProfilePhotos'] != null
        ? new ProfilePhotos.fromJson(json['ProfilePhotos'])
        : null;
    usersReference = json['usersReference'] != null
        ? new UsersReference.fromJson(json['usersReference'])
        : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userPic'] = this.userPic;
    data['lastLogin'] = this.lastLogin;
    data['refeN'] = this.refeN;
    data['city'] = this.city;
    data['country'] = this.country;
    data['workStatus'] = this.workStatus;
    data['languages'] = this.languages;
    if (this.workFields != null) {
      // data['workFields'] = this.workFields.map((v) => v.toJson()).toList();
    }
    data['bio'] = this.bio;
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['fullName'] = this.fullName;
    data['userType'] = this.userType;
    if (this.profilePhotos != null) {
      data['ProfilePhotos'] = this.profilePhotos.toJson();
    }
    if (this.usersReference != null) {
      data['usersReference'] = this.usersReference.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class ProfilePhotos {
  List<Photo> photosList;

  ProfilePhotos({this.photosList});

  ProfilePhotos.fromJson(Map<String, dynamic> json) {
    if (json['photosList'] != null) {
      photosList = <Photo>[];
      json['photosList'].forEach((v) {
        photosList.add(new Photo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.photosList != null) {
      data['photosList'] = this.photosList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Photo {
  String sId;
  String url;

  Photo({this.sId, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['url'] = this.url;
    return data;
  }
}

class Reference {
  bool approved;
  String _id;
  String text;
  ReferenceFrom from;

  Reference.fromJson(Map<String, dynamic> json) {
    approved = json["approved"];
    _id = json["_id"];
    text = json["text"];
    from = ReferenceFrom.fromJson(json["from"]);
  }
}

class ReferenceFrom {
  String userPic;
  String _id;
  String username;
  String fullName;

  ReferenceFrom.fromJson(Map<String, dynamic> json) {
    userPic = json["userPic"];
    _id = json["_id"];
    username = json["username"];
    fullName = json["fullName"];
  }
}

class UsersReference {
  List<Reference> refList;

  UsersReference({this.refList});

  UsersReference.fromJson(Map<String, dynamic> json) {
    if (json['refList'] != null) {
      refList = <Reference>[];
      json['refList'].forEach((v) {
        refList.add(new Reference.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.refList != null) {
      // data['refList'] = this.refList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
