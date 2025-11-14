// To parse this JSON data, do
//
//     final addemployeeModel = addemployeeModelFromJson(jsonString);

import 'dart:convert';

import 'package:attendance_web/model/employee/getallemployeemodel.dart';

AddemployeeModel addemployeeModelFromJson(String str) => AddemployeeModel.fromJson(json.decode(str));

String addemployeeModelToJson(AddemployeeModel data) => json.encode(data.toJson());

class AddemployeeModel {
    bool status;
    String message;
     EmployeeList? data; 

    AddemployeeModel({
        required this.status,
        required this.message,
        
             this.data
    });

    factory AddemployeeModel.fromJson(Map<String, dynamic> json) => AddemployeeModel(
        status: json["status"],
        message: json["message"],
         data: json["data"] != null
            ? EmployeeList.fromJson(json["data"])
            : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
          "data": data?.toJson(),
    };
}
