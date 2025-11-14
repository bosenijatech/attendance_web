// To parse this JSON data, do
//
//     final getallemployeeModel = getallemployeeModelFromJson(jsonString);

import 'dart:convert';

GetallemployeeModel getallemployeeModelFromJson(String str) => GetallemployeeModel.fromJson(json.decode(str));

String getallemployeeModelToJson(GetallemployeeModel data) => json.encode(data.toJson());

class GetallemployeeModel {
    bool status;
    String message;
    List<EmployeeList> data;

    GetallemployeeModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory GetallemployeeModel.fromJson(Map<String, dynamic> json) => GetallemployeeModel(
        status: json["status"],
        message: json["message"],
        data: List<EmployeeList>.from(json["data"].map((x) => EmployeeList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class EmployeeList {
    String? id;
    String? employeeid;
    String? employeename;
    String? employeeemail;
    String? type;
    String? status;

    EmployeeList({
         this.id,
         this.employeeid,
         this.employeename,
         this.employeeemail,
         this.type,
         this.status,
    });

    factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
        id: json["id"],
        employeeid: json["employeeid"],
        employeename: json["employeename"],
        employeeemail: json["employeeemail"],
        type: json["type"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeid": employeeid,
        "employeename": employeename,
        "employeeemail": employeeemail,
        "type": type,
        "status": status,
    };
}
