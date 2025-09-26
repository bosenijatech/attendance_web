import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/app_constants.dart';
import '../model/supervisor/addsupervisormodel.dart';


class AttendanceApiService {
  static String liveApiPath = AppConstants.apiBaseUrl;
  // static String liveImgPath = AppConstants.imgBaseUrl;

  final http.Client client = http.Client();

  Map<String, String>? headerData;

  AttendanceApiService();

  /// Get headers with Bearer Token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Appplatform': 'Android',
      'App-type': '$userId',
      // 'Authorization': 'Bearer $token',
    };
  }

  /// Get all Supervisor
  Future<dynamic> getAllSupervisor() async {
    try {
      final url = Uri.parse('${liveApiPath}getallSupervisors');
      final headers = await _getHeaders();

      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // ✅ parse JSON
      } else {
        return {
          "error": true,
          "status": response.statusCode,
          "message": response.body,
        };
      }
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }

  //add Supervisor
//   Future<AddsupervisorsModel> AddSupervisor(Map<String, dynamic> postData) async {
//   try {
//     final url = Uri.parse('${liveApiPath}addSupervisor');
//     final response = await client.post(
//       url,
//       headers: headerData,
//       body: jsonEncode(postData),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonMap = jsonDecode(response.body);
//       return AddsupervisorsModel.fromJson(jsonMap);
//     } else {
//       throw Exception('Failed to add supervisor: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Error: $e');
//   }
// }



  Future AddSupervisor(postData) async {
    print("test api");
    try {
      final url = Uri.parse('${liveApiPath}addSupervisor');
      final response = await client.post(url,
          headers: headerData, body: jsonEncode(postData));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response;
      }
    } catch (e) {
      return e;
    }
  }


}
