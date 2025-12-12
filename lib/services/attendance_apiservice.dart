


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/app_constants.dart';
import '../model/allocation/addallocationmodel.dart';
import '../model/allocation/getallallocationmodel.dart';
import '../model/employee/addemployeemodel.dart';
import '../model/employee/getallemployeemodel.dart';
import '../model/login/loginscreenmodel.dart';
import '../model/projectmaster/addprojectmodel.dart';
import '../model/projectmaster/getallprojectmodel.dart';
import '../model/site/addsitemodel.dart';
import '../model/site/getallsitemodel.dart';
import '../model/supervisor/addsupervisormodel.dart';
import '../model/supervisor/editsupervisormodel.dart';
import '../model/supervisor/getallsupervisormodel.dart';

class AttendanceApiService {
  static String liveApiPath = AppConstants.apiBaseUrl;
  final http.Client client = http.Client();

  AttendanceApiService();

  /// Get headers with Bearer Token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    return {
      'Content-Type': 'application/json',  
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Login API
  
  Future<LoginscreenModel> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${liveApiPath}login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        final loginModel = LoginscreenModel.fromJson(jsonMap);

        if (loginModel.status == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', loginModel.token ?? '');
          await prefs.setString('user_role', loginModel.role ?? '');
        }

        return loginModel;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



  
  Future<GetallsupervisorsModel> getAllSupervisor() async {
  try {
    final url = Uri.parse('${liveApiPath}getallSupervisors');
   

    final headers = await _getHeaders();
   

    final response = await http.get(url, headers: headers);
   

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
  
      return GetallsupervisorsModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load supervisors');
    }
  } catch (e) {
    print('Error occurred: $e'); // ✅ Print any caught error
    throw Exception('Error: $e');
  }
}


  // Add supervisor with token
  Future<AddsupervisorscreenModel> addSupervisor(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}addSupervisor");
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddsupervisorscreenModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add supervisor");
    }
  }

  // Edit supervisor with token
  Future<AddsupervisorscreenModel> editSupervisor(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}editSupervisor");
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddsupervisorscreenModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to edit supervisor");
    }
  }


//deletesupervisor


Future<AddsupervisorscreenModel> deleteSupervisor(String id) async {
  final url = Uri.parse("${liveApiPath}deleteSupervisor");
  final headers = await _getHeaders();

  final response = await http.delete(
    url,
    headers: headers,
    body: jsonEncode({"id": id}), // 👈 send ID inside body
  );

  if (response.statusCode == 200) {
    return AddsupervisorscreenModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to delete supervisor");
  }
}




   // Get all Site with token
  Future<GetallsiteModel> getAllSite() async {
    try {
      final url = Uri.parse('${liveApiPath}getallSite');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return GetallsiteModel.fromJson(jsonMap);
      } else {
        throw Exception('Failed to load supervisors');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


 // Add Site with token
  Future<AddsiteModel> addSite(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}addSite");
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddsiteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add site");
    }
  }

  // Edit Site with token
  Future<AddsiteModel> editSite(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}editsite");
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddsiteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to edit site");
    }
  }


  
//deleteSite
Future<AddsiteModel> deleteSite(String id) async {
  final url = Uri.parse("${liveApiPath}deleteSite");
  final headers = await _getHeaders();

  final response = await http.delete(
    url,
    headers: headers,
    body: jsonEncode({"id": id}), // 👈 send ID inside body
  );

  if (response.statusCode == 200) {
    return AddsiteModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to delete Site");
  }
}


   // Get all Project with token
  Future<GetallprojectscreenModel> getAllProject() async {
    try {
      final url = Uri.parse('${liveApiPath}getallProject');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return GetallprojectscreenModel.fromJson(jsonMap);
      } else {
        throw Exception('Failed to load Project');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


 // Add Project with token
  Future<AddprojectscreenModel> addProject(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}addProject");
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddprojectscreenModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add project");
    }
  }

  // Edit Project with token
  Future<AddprojectscreenModel> editProject(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}editProject");
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddprojectscreenModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to edit project");
    }
  }




  
//deleteProject
Future<AddprojectscreenModel> deleteProject(String id) async {
  final url = Uri.parse("${liveApiPath}deleteProject");
  final headers = await _getHeaders();

  final response = await http.delete(
    url,
    headers: headers,
    body: jsonEncode({"id": id}), // 👈 send ID inside body
  );

  if (response.statusCode == 200) {
    return AddprojectscreenModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to delete Project");
  }
}


   // Get all Employee with token
  Future<GetallemployeeModel> getAllEmployee() async {
    try {
      final url = Uri.parse('${liveApiPath}getallEmployee');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return GetallemployeeModel.fromJson(jsonMap);
      } else {
        throw Exception('Failed to load Employee');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  


 // Add Employee with token
  Future<AddemployeeModel> addEmployee(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}addEmployee");
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddemployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add Employee");
    }
  }

  // Edit Employee with token
  Future<AddemployeeModel> editEmployee(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}editEmployee");
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      return AddemployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to edit Employee");
    }
  }

//deleteEmployee
Future<AddemployeeModel> deleteEmployee(String id) async {
  final url = Uri.parse("${liveApiPath}deleteEmployee");
  final headers = await _getHeaders();

  final response = await http.delete(
    url,
    headers: headers,
    body: jsonEncode({"id": id}), // 👈 send ID inside body
  );

  if (response.statusCode == 200) {
    return AddemployeeModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to delete Employee");
  }
}

   // Get all Allocation with token
  Future<GetallallocationModel> getAllAllocation() async {
    try {
      final url = Uri.parse('${liveApiPath}getAllAllocations');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
       print("DECODED JSON: $jsonMap");

        return GetallallocationModel.fromJson(jsonMap);
      } else {
        throw Exception('Failed to load Allocation');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


 // Add Allocation with token
  Future<AddallocationModel> addAllocation(Map<String, dynamic> postData) async {
    final url = Uri.parse("${liveApiPath}addAllocation");
    final headers = await _getHeaders();
  print("📦 Body: ${jsonEncode(postData)}");
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );
  print("📥 Response Status: ${response.statusCode}");
  print("📥 Response Body: ${response.body}");
    if (response.statusCode == 200) {
      return AddallocationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add Allocation");
    }
  }

  

  Future<AddallocationModel> editAllocation(Map<String, dynamic> postData) async {
  final url = Uri.parse("${liveApiPath}editAllocation");
  final headers = await _getHeaders();



  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(postData),
  );



  if (response.statusCode == 200) {
    return AddallocationModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to edit Allocation");
  }
}



//deleteAllocation
Future<AddallocationModel> deleteAllocation(String id) async {
  final url = Uri.parse("${liveApiPath}deleteAllocation");
  final headers = await _getHeaders();

  final response = await http.delete(
    url,
    headers: headers,
    body: jsonEncode({"id": id}), // 👈 send ID inside body
  );

  if (response.statusCode == 200) {
    return AddallocationModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to delete Allocation");
  }
}


}
