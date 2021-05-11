class User {
  String status;
  String token;
  String userType;

  static String authToken;
  User({this.status, this.token, this.userType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json['status'],
      token: json['token'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'token': token,
        'userType': userType,
      };
}
