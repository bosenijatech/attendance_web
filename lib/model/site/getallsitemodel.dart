// To parse this JSON data, do
//
//     final getallsiteModel = getallsiteModelFromJson(jsonString);

import 'dart:convert';

GetallsiteModel getallsiteModelFromJson(String str) => GetallsiteModel.fromJson(json.decode(str));

String getallsiteModelToJson(GetallsiteModel data) => json.encode(data.toJson());

class GetallsiteModel {
    bool status;
    String message;
    List<Sitelist> data;

    GetallsiteModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory GetallsiteModel.fromJson(Map<String, dynamic> json) => GetallsiteModel(
        status: json["status"],
        message: json["message"],
        data: List<Sitelist>.from(json["data"].map((x) => Sitelist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Sitelist {
    String? siteid;
    String? sitename;
    String? siteaddress;
    String? sitecity;
    String? status;
    String? id;

    Sitelist({
         this.siteid,
         this.sitename,
         this.siteaddress,
         this.sitecity,
         this.status,
         this.id,
    });

    factory Sitelist.fromJson(Map<String, dynamic> json) => Sitelist(
        siteid: json["siteid"],
        sitename: json["sitename"],
        siteaddress: json["siteaddress"],
        sitecity: json["sitecity"],
        status: json["status"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "siteid": siteid,
        "sitename": sitename,
        "siteaddress": siteaddress,
        "sitecity": sitecity,
        "status": status,
        "id": id,
    };
}
