class User {
  String status;
  String token;
  String userType;
  String id;

  static String authToken;
  static String userId;
  User({this.status, this.token, this.userType, this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        status: json['status'],
        token: json['token'],
        userType: json['userType'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'token': token,
        'userType': userType,
        'id': id,
      };
}
