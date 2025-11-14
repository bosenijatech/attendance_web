// To parse this JSON data, do
//
//     final loginscreenModel = loginscreenModelFromJson(jsonString);

import 'dart:convert';

LoginscreenModel loginscreenModelFromJson(String str) => LoginscreenModel.fromJson(json.decode(str));

String loginscreenModelToJson(LoginscreenModel data) => json.encode(data.toJson());

class LoginscreenModel {
    bool? status;
    String? message;
    String? token;
    String? role;

    LoginscreenModel({
         this.status,
         this.message,
         this.token,
         this.role,
    });

    factory LoginscreenModel.fromJson(Map<String, dynamic> json) => LoginscreenModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "role": role,
    };
}
