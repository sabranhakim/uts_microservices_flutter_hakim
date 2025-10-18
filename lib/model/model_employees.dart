// To parse this JSON data, do
//
//     final modelEmployees = modelEmployeesFromJson(jsonString);

import 'dart:convert';

ModelEmployees modelEmployeesFromJson(String str) =>
    ModelEmployees.fromJson(json.decode(str));

String modelEmployeesToJson(ModelEmployees data) => json.encode(data.toJson());

class ModelEmployees {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelEmployees({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelEmployees.fromJson(Map<String, dynamic> json) => ModelEmployees(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  String posistion;
  String phone;
  String email;
  String address;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.posistion,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    posistion: json["posistion"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "posistion": posistion,
    "phone": phone,
    "email": email,
    "address": address,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
