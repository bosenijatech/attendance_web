import 'package:attendance_web/screens/adminscreen.dart';
import 'package:attendance_web/screens/employeemaster/employeemaster.dart';
import 'package:attendance_web/screens/projectallocation/projectallocation.dart';
import 'package:attendance_web/screens/projectmaster/projectmaster.dart';
import 'package:attendance_web/screens/sitemaster/sitemasterscreen.dart';
import 'package:attendance_web/screens/supervisormaster/supervisormaster.dart';
import 'package:get/get.dart';

import '../authscreen/loginscreen.dart';
import '../screens/dashboard/dashboardscreen.dart';



final List<GetPage> getPages = [

  GetPage(name: '/login', page: () =>  Loginscreen()),
  GetPage(name: '/dashboard', page: () =>  AdminScreen()),
  GetPage(name: '/dashboard', page: () =>  DashboardScreen()),
  GetPage(name: '/dashboard', page: () =>  Sitemasterscreen(onAdd: () {  }, onEdit: () {  },)),
  GetPage(name: '/dashboard', page: () =>  ProjectmasterScreen(onAdd: () {  }, onEdit: () {  },)),
  GetPage(name: '/dashboard', page: () =>  SupervisormasterScreen(onAdd: () {  }, onEdit: () {  }, supervisors: [],)),
  GetPage(name: '/dashboard', page: () =>  EmployeemasterScreen(onAdd: () {  }, onEdit: () {  },)),
  GetPage(name: '/dashboard', page: () =>  ProjectallocationScreen(onAdd: () {  }, isEdit:false , onEdit: () {  },)),

];
