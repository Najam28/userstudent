// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.userId,
    required this.userName,
    required this.passwordHash,
    required this.passwordSalt,
    required this.refreshToken,
    required this.tokenCreated,
    required this.tokenExpire,
  });

  int userId;
  String userName;
  String passwordHash;
  String passwordSalt;
  String refreshToken;
  DateTime tokenCreated;
  DateTime tokenExpire;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        userName: json["userName"],
        passwordHash: json["passwordHash"],
        passwordSalt: json["passwordSalt"],
        refreshToken: json["refreshToken"],
        tokenCreated: DateTime.parse(json["tokenCreated"]),
        tokenExpire: DateTime.parse(json["tokenExpire"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "passwordHash": passwordHash,
        "passwordSalt": passwordSalt,
        "refreshToken": refreshToken,
        "tokenCreated": tokenCreated.toIso8601String(),
        "tokenExpire": tokenExpire.toIso8601String(),
      };
}
