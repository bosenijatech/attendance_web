// To parse this JSON data, do
//
//     final addprojectscreenModel = addprojectscreenModelFromJson(jsonString);

import 'dart:convert';

import 'getallprojectmodel.dart';

AddprojectscreenModel addprojectscreenModelFromJson(String str) => AddprojectscreenModel.fromJson(json.decode(str));

String addprojectscreenModelToJson(AddprojectscreenModel data) => json.encode(data.toJson());

class AddprojectscreenModel {
    bool status;
    String message;
     Projectlist? data; 

    AddprojectscreenModel({
        required this.status,
        required this.message,
             this.data
    });

    factory AddprojectscreenModel.fromJson(Map<String, dynamic> json) => AddprojectscreenModel(
        status: json["status"],
        message: json["message"],
          data: json["data"] != null
            ? Projectlist.fromJson(json["data"])
            : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
          "data": data?.toJson(),
    };
}
