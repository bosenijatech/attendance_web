// To parse this JSON data, do
//
//     final addsiteModel = addsiteModelFromJson(jsonString);

import 'dart:convert';

import 'getallsitemodel.dart';

AddsiteModel addsiteModelFromJson(String str) => AddsiteModel.fromJson(json.decode(str));

String addsiteModelToJson(AddsiteModel data) => json.encode(data.toJson());

class AddsiteModel {
    bool status;
    String message;
     Sitelist? data; 

    AddsiteModel({
        required this.status,
        required this.message,
        this.data
    });

    factory AddsiteModel.fromJson(Map<String, dynamic> json) => AddsiteModel(
        status: json["status"],
        message: json["message"],
         data: json["data"] != null
            ? Sitelist.fromJson(json["data"])
            : null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}
