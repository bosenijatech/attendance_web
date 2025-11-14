import 'package:attendance_web/authscreen/landingpage.dart';
import 'package:get/get.dart';
import '../model/allocation/getallallocationmodel.dart';
import '../model/employee/getallemployeemodel.dart';
import '../model/projectmaster/getallprojectmodel.dart';
import '../model/site/getallsitemodel.dart';
import '../screens/adminscreen.dart';
import '../screens/employeemaster/employeemaster.dart';
import '../screens/projectallocation/allocationmaster.dart';


import '../screens/projectmaster/projectmasterscreen.dart';
import '../screens/sitemaster/sitemasterscreen.dart';

import '../screens/supervisormaster/supervisormaster.dart';
import '../authscreen/loginscreen.dart';
import '../screens/dashboard/dashboardscreen.dart';
import '../../model/supervisor/getallsupervisormodel.dart';

final List<GetPage> getPages = [
  GetPage(name: '/', page: () => LandingPage()),
  GetPage(name: '/login', page: () => Loginscreen()),
  GetPage(name: '/admin', page: () => const AdminScreen()),

  GetPage(name: '/dashboard', page: () => const DashboardScreen()),
  GetPage(
      name: '/sitemaster',
      page: () => Sitemasterscreen(onAdd: () {
         print("Add site clicked");
      }, onEdit: (Sitelist site) {
         print("Edit site clicked: ${site.sitename}");
      }, site: [],)),
  GetPage(
      name: '/projectmaster',
      page: () => ProjectmasterScreen(onAdd: () {
           print("Add Project clicked");
      }, onEdit: (Projectlist project) {
         print("Edit Project clicked: ${project.projectname}");
      }, project: [],)),
  GetPage(
      name: '/supervisormaster',
      page: () => SupervisormasterScreen(
            supervisors: [],
            onAdd: () {
              print("Add supervisor clicked");
            },
            onEdit: (Supervisorlist supervisor) {
              print("Edit supervisor clicked: ${supervisor.supervisorname}");
            },
          )),
  GetPage(
      name: '/employeemaster',
      page: () => EmployeemasterScreen(onAdd: () {
           print("Add Employee clicked");
      }, onEdit: (EmployeeList employee) {
        print("Edit Employee clicked: ${employee.employeename}");
      }, employee: [],)),
  GetPage(
      name: '/projectallocation',
      page: () => AllocationmasterScreen(
            onAdd: () {
                print("Add Allocation clicked");
            },
          
            onEdit: (Allocationlist allocation) {
  print("Edit Allocation clicked: ${allocation.projectname}");
            }, allocation: [],
          )),
];

