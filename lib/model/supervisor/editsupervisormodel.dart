


// To parse this JSON data, do
//
//     final editsupervisorscreenModel = editsupervisorscreenModelFromJson(jsonString);

import 'dart:convert';

EditsupervisorscreenModel editsupervisorscreenModelFromJson(String str) => EditsupervisorscreenModel.fromJson(json.decode(str));

String editsupervisorscreenModelToJson(EditsupervisorscreenModel data) => json.encode(data.toJson());

class EditsupervisorscreenModel {
    bool status;
    String message;

    EditsupervisorscreenModel({
        required this.status,
        required this.message,
    });

    factory EditsupervisorscreenModel.fromJson(Map<String, dynamic> json) => EditsupervisorscreenModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
