// To parse this JSON data, do
//
//     final getallprojectscreenModel = getallprojectscreenModelFromJson(jsonString);

import 'dart:convert';

GetallprojectscreenModel getallprojectscreenModelFromJson(String str) => GetallprojectscreenModel.fromJson(json.decode(str));

String getallprojectscreenModelToJson(GetallprojectscreenModel data) => json.encode(data.toJson());

class GetallprojectscreenModel {
    bool status;
    String message;
    List<Projectlist> data;

    GetallprojectscreenModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory GetallprojectscreenModel.fromJson(Map<String, dynamic> json) => GetallprojectscreenModel(
        status: json["status"],
        message: json["message"],
        data: List<Projectlist>.from(json["data"].map((x) => Projectlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Projectlist {
    String? projectid;
    String? projectname;
    String? projectaddress;
    String? status;
    String? id;

    Projectlist({
         this.projectid,
         this.projectname,
         this.projectaddress,
         this.status,
         this.id,
    });

    factory Projectlist.fromJson(Map<String, dynamic> json) => Projectlist(
        projectid: json["projectid"],
        projectname: json["projectname"],
        projectaddress: json["projectaddress"],
        status: json["status"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "projectid": projectid,
        "projectname": projectname,
        "projectaddress": projectaddress,
        "status": status,
        "id": id,
    };
}
