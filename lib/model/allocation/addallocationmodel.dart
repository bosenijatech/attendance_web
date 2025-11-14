// To parse this JSON data, do
//
//     final addallocationModel = addallocationModelFromJson(jsonString);

import 'dart:convert';

import 'package:attendance_web/model/allocation/getallallocationmodel.dart';

AddallocationModel addallocationModelFromJson(String str) => AddallocationModel.fromJson(json.decode(str));

String addallocationModelToJson(AddallocationModel data) => json.encode(data.toJson());

class AddallocationModel {
    bool status;
    String message;
 Allocationlist? data; 

    AddallocationModel({
        required this.status,
        required this.message,
           this.data
    });

    factory AddallocationModel.fromJson(Map<String, dynamic> json) => AddallocationModel(
        status: json["status"],
        message: json["message"],
         data: json["data"] != null
            ? Allocationlist.fromJson(json["data"])
            : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
           "data": data?.toJson(),
    };
}
