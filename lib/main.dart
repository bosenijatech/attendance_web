


import 'package:attendance_web/bloc/bloc/allocation/allocation_bloc.dart';
import 'package:attendance_web/bloc/bloc/employee/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc/projectmaster/project_bloc.dart';
import 'bloc/bloc/site/site_bloc.dart';
import 'bloc/bloc/supervisor/supervisor_bloc.dart';
import 'services/attendance_apiservice.dart'; // import your service
import 'constant/app_color.dart';
import 'router/getx_routes.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('KeyDownEvent')) {
      // ignore the known keyboard bug
      return;
    }
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceApiService = AttendanceApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SupervisorBloc(attendanceApiService),
          
        ),
        BlocProvider(
      create: (_) => SiteBloc(attendanceApiService),
    ),
        BlocProvider(
      create: (_) => ProjectBloc(attendanceApiService),
    ),
        BlocProvider(
      create: (_) => EmployeeBloc(attendanceApiService),
    ),
        BlocProvider(
      create: (_) => AllocationBloc(attendanceApiService),
    ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        getPages: getPages,
        theme: ThemeData(
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}


