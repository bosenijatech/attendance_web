


// To parse this JSON data, do
//
//     final getallallocationModel = getallallocationModelFromJson(jsonString);

import 'dart:convert';

GetallallocationModel getallallocationModelFromJson(String str) => GetallallocationModel.fromJson(json.decode(str));

String getallallocationModelToJson(GetallallocationModel data) => json.encode(data.toJson());

class GetallallocationModel {
    bool status;
    List<Allocationlist> data;

    GetallallocationModel({
        required this.status,
        required this.data,
    });

    factory GetallallocationModel.fromJson(Map<String, dynamic> json) => GetallallocationModel(
        status: json["status"],
        data: List<Allocationlist>.from(json["data"].map((x) => Allocationlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Allocationlist {
    String? id;
    String? allocationid;
    String? supervisorid;
    String? supervisorname;
    List<Employee>? employee;
    String? projectid;
    String? projectname;
    String? siteid;
    String? sitename;
    String? fromDate;
    String? toDate;
    String? status;
    int? syncstaus;
    DateTime? currentDate;
    DateTime? createdAt;

    Allocationlist({
         this.id,
         this.allocationid,
        this.supervisorid,
         this.supervisorname,
         this.employee,
        this.projectid,
         this.projectname,
        this.siteid,
         this.sitename,
         this.fromDate,
         this.toDate,
         this.status,
         this.syncstaus,
         this.currentDate,
         this.createdAt,
    });

    factory Allocationlist.fromJson(Map<String, dynamic> json) => Allocationlist(
        id: json["id"],
        allocationid: json["allocationid"],
        supervisorid: json["supervisorid"],
        supervisorname: json["supervisorname"],
        employee: List<Employee>.from(json["employee"].map((x) => Employee.fromJson(x))),
        projectid: json["projectid"],
        projectname: json["projectname"],
        siteid: json["siteid"],
        sitename: json["sitename"],
        fromDate: json["fromDate"],
        toDate: json["toDate"],
        status: json["status"],
        syncstaus: json["syncstaus"],
        currentDate: DateTime.parse(json["currentDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "allocationid": allocationid,
        "supervisorid": supervisorid,
        "supervisorname": supervisorname,
        "employee": List<dynamic>.from(employee!.map((x) => x.toJson())),
        "projectid": projectid,
        "projectname": projectname,
        "siteid": siteid,
        "sitename": sitename,
        "fromDate": fromDate,
        "toDate": toDate,
        "status": status,
        "syncstaus": syncstaus,
        "currentDate": currentDate!.toIso8601String(),
        "createdAt": createdAt!.toIso8601String(),
    };
}

class Employee {
    String? employeeid;
    String? employeename;
    String? attendancestatus;
    String? id;

    Employee({
        this.employeeid,
         this.employeename,
         this.attendancestatus,
         this.id,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        employeeid: json["employeeid"],
        employeename: json["employeename"],
        attendancestatus: json["attendancestatus"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "employeeid": employeeid,
        "employeename": employeename,
        "attendancestatus": attendancestatus,
        "id": id,
    };
}
