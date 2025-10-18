// To parse this JSON data, do
//
//     final modelUser = modelUserFromJson(jsonString);

import 'dart:convert';

ModelUser modelUserFromJson(String str) => ModelUser.fromJson(json.decode(str));

String modelUserToJson(ModelUser data) => json.encode(data.toJson());

class ModelUser {
  bool isSuccess;
  String message;
  User user;

  ModelUser({
    required this.isSuccess,
    required this.message,
    required this.user,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
    isSuccess: json["isSuccess"],
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "user": user.toJson(),
  };
}

class User {
  int id;
  String username;

  User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], username: json["username"]);

  Map<String, dynamic> toJson() => {"id": id, "username": username};
}
