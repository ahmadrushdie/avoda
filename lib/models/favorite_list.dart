class FavoriteList {
  List<Favorite> favorites;

  FavoriteList({this.favorites});

  FavoriteList.fromJson(Map<String, dynamic> json) {
    if (json['favorites'] != null) {
      favorites = <Favorite>[];
      json['favorites'].forEach((v) {
        favorites.add(new Favorite.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.favorites != null) {
      data['favorites'] = this.favorites.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Favorite {
  Null userPic;
  String sId;
  String fullName;

  Favorite({this.userPic, this.sId, this.fullName});

  Favorite.fromJson(Map<String, dynamic> json) {
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
