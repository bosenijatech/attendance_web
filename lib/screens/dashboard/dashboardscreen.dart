// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/bloc/allocation/allocation_bloc.dart';
// import '../../bloc/bloc/employee/employee_bloc.dart';
// import '../../bloc/bloc/projectmaster/project_bloc.dart';
// import '../../bloc/bloc/site/site_bloc.dart';
// import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
// import '../../bloc/event/allocation/allocation_event.dart';
// import '../../bloc/event/employee/employee_event.dart';
// import '../../bloc/event/projectmaster/project_event.dart';
// import '../../bloc/event/site/site_event.dart';
// import '../../bloc/event/supervisor/supervisor_event.dart';
// import '../../bloc/state/allocation/allocation_state.dart';
// import '../../bloc/state/employee/employee_state.dart';
// import '../../bloc/state/projectmaster/project_state.dart';
// import '../../bloc/state/site/site_state.dart';
// import '../../bloc/state/supervisor/supervisor_state.dart';
// import '../../constant/app_color.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int siteCount = 0;
//   int projectCount = 0;
//   int supervisorCount = 0;
//   int employeeCount = 0;
//   int allocationCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     context.read<SiteBloc>().add(FetchSiteEvent());
//     context.read<ProjectBloc>().add(FetchProjectEvent());
//     context.read<SupervisorBloc>().add(FetchSupervisorsEvent());
//     context.read<EmployeeBloc>().add(FetchEmployeeEvent());
//     context.read<AllocationBloc>().add(FetchAllocationEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: MultiBlocListener(
//             listeners: [
//               BlocListener<SiteBloc, SiteState>(
//                 listener: (context, state) {
//                   if (state is SiteLoaded) {
//                     setState(() => siteCount = state.site.length);
//                   }
//                 },
//               ),
//               BlocListener<ProjectBloc, ProjectState>(
//                 listener: (context, state) {
//                   if (state is ProjectLoaded) {
//                     setState(() => projectCount = state.project.length);
//                   }
//                 },
//               ),
//               BlocListener<SupervisorBloc, SupervisorState>(
//                 listener: (context, state) {
//                   if (state is SupervisorLoaded) {
//                     setState(() => supervisorCount = state.supervisors.length);
//                   }
//                 },
//               ),
//               BlocListener<EmployeeBloc, EmployeeState>(
//                 listener: (context, state) {
//                   if (state is EmployeeLoaded) {
//                     setState(() => employeeCount = state.employee.length);
//                   }
//                 },
//               ),
//               BlocListener<AllocationBloc, AllocationState>(
//                 listener: (context, state) {
//                   if (state is AllocationLoaded) {
//                     setState(() => allocationCount = state.allocation.length);
//                   }
//                 },
//               ),
//             ],
//             child: _buildDashboardUI(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDashboardUI() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
  

//         // Grid Cards
//         Expanded(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               int crossAxisCount = constraints.maxWidth < 700 ? 2 : 3;
//               return GridView.count(
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20,
//                 childAspectRatio: 2.8,
//                 children: [
//                   _buildStatCard(
//                     title: "Sites",
//                     count: siteCount,
//                     icon: Icons.location_on_rounded,
//                     color: Colors.indigo,
//                   ),
//                   _buildStatCard(
//                     title: "Projects",
//                     count: projectCount,
//                     icon: Icons.engineering_rounded,
//                     color: Colors.teal,
//                   ),
//                   _buildStatCard(
//                     title: "Supervisors",
//                     count: supervisorCount,
//                     icon: Icons.supervisor_account_rounded,
//                     color: Colors.deepPurple,
//                   ),
//                   _buildStatCard(
//                     title: "Employees",
//                     count: employeeCount,
//                     icon: Icons.people_alt_rounded,
//                     color: Colors.orange,
//                   ),
//                   _buildStatCard(
//                     title: "Allocations",
//                     count: allocationCount,
//                     icon: Icons.assignment_turned_in_rounded,
//                     color: Colors.blueGrey,
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required int count,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: 54,
//             width: 54,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(width: 18),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     color: Color(0xFF7B8A8C),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   count.toString(),
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/bloc/allocation/allocation_bloc.dart';
// import '../../bloc/bloc/employee/employee_bloc.dart';
// import '../../bloc/bloc/projectmaster/project_bloc.dart';
// import '../../bloc/bloc/site/site_bloc.dart';
// import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
// import '../../bloc/event/allocation/allocation_event.dart';
// import '../../bloc/event/employee/employee_event.dart';
// import '../../bloc/event/projectmaster/project_event.dart';
// import '../../bloc/event/site/site_event.dart';
// import '../../bloc/event/supervisor/supervisor_event.dart';
// import '../../bloc/state/allocation/allocation_state.dart';
// import '../../bloc/state/employee/employee_state.dart';
// import '../../bloc/state/projectmaster/project_state.dart';
// import '../../bloc/state/site/site_state.dart';
// import '../../bloc/state/supervisor/supervisor_state.dart';
// import '../../constant/app_color.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int siteCount = 0;
//   int siteActiveCount = 0;
//   int siteInactiveCount = 0;

//   int projectCount = 0;
//   int projectActiveCount = 0;
//   int projectInactiveCount = 0;

//   int supervisorCount = 0;
//   int supervisorActiveCount = 0;
//   int supervisorInactiveCount = 0;

//   int employeeCount = 0;
//   int employeeActiveCount = 0;
//   int employeeInactiveCount = 0;

//   int allocationCount = 0;
//   int allocationActiveCount = 0;
//   int allocationInactiveCount = 0;

//     Map<String, int> employeeTypeCount = {
//     "Permanent": 0,
//     "Temporary": 0,
//     "Contract": 0,
//   };

//   @override
//   void initState() {
//     super.initState();
//     context.read<SiteBloc>().add(FetchSiteEvent());
//     context.read<ProjectBloc>().add(FetchProjectEvent());
//     context.read<SupervisorBloc>().add(FetchSupervisorsEvent());
//     context.read<EmployeeBloc>().add(FetchEmployeeEvent());
//     context.read<AllocationBloc>().add(FetchAllocationEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: MultiBlocListener(
//             listeners: [
//               BlocListener<SiteBloc, SiteState>(
//                 listener: (context, state) {
//                   if (state is SiteLoaded) {
//                     setState(() {
//                       siteCount = state.site.length;
//                       siteActiveCount =
//                           state.site.where((s) => s.status == "Active").length;
//                       siteInactiveCount =
//                           state.site.where((s) => s.status == "Inactive").length;
//                     });
//                   }
//                 },
//               ),
//               BlocListener<ProjectBloc, ProjectState>(
//                 listener: (context, state) {
//                   if (state is ProjectLoaded) {
//                     setState(() {
//                       projectCount = state.project.length;
//                       projectActiveCount =
//                           state.project.where((p) => p.status== "Active").length;
//                       projectInactiveCount =
//                           state.project.where((p) => p.status == "Inactive").length;
//                     });
//                   }
//                 },
//               ),
//               BlocListener<SupervisorBloc, SupervisorState>(
//                 listener: (context, state) {
//                   if (state is SupervisorLoaded) {
//                     setState(() {
//                       supervisorCount = state.supervisors.length;
//                       supervisorActiveCount =
//                           state.supervisors.where((s) => s.status== "Active").length;
//                       supervisorInactiveCount =
//                           state.supervisors.where((s) => s.status == "Inactive").length;
//                     });
//                   }
//                 },
//               ),
         
      
//               BlocListener<EmployeeBloc, EmployeeState>(
//         listener: (context, state) {
//           if (state is EmployeeLoaded) {
//       setState(() {
//         employeeCount = state.employee.length;
//         employeeActiveCount =
//             state.employee.where((e) => e.status == "Active").length;
//         employeeInactiveCount =
//             state.employee.where((e) => e.status == "Inactive").length;
      
//         // 🔹 Reset and count by employeeType
//         employeeTypeCount = {
//           "Permanent": 0,
//           "Temporary": 0,
//           "Contract": 0,
//         };
      
//         for (var emp in state.employee) {
//           final type = emp.type?.trim() ?? "";
//           if (employeeTypeCount.containsKey(type)) {
//             employeeTypeCount[type] = employeeTypeCount[type]! + 1;
//           } else {
//             employeeTypeCount["Temporary"] =
//                 (employeeTypeCount["Temporary"] ?? 0) + 1;
//           }
//         }
//       });
//           }
//         },
//       ),
      
//               BlocListener<AllocationBloc, AllocationState>(
//                 listener: (context, state) {
//                   if (state is AllocationLoaded) {
//                     setState(() {
//                       allocationCount = state.allocation.length;
//                       allocationActiveCount =
//                           state.allocation.where((a) => a.status == "Active").length;
//                       allocationInactiveCount =
//                           state.allocation.where((a) => a.status == "Inactive").length;
//                     });
//                   }
//                 },
//               ),
//             ],
//             child: _buildDashboardUI(),
//           ),
//         ),
//       ),
//     );
//   }

//  Widget _buildDashboardUI() {
//   return SingleChildScrollView(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 🟢 Top Grid Section
//         LayoutBuilder(
//           builder: (context, constraints) {
//             int crossAxisCount = constraints.maxWidth < 700 ? 2 : 3;
//             return GridView.count(
//               crossAxisCount: crossAxisCount,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 3,
//               physics: const NeverScrollableScrollPhysics(), // disable inner scroll
//               shrinkWrap: true, // let grid fit inside scroll
//               children: [
//                 _buildStatCard(
//                   title: "Sites",
//                   total: siteCount,
//                   active: siteActiveCount,
//                   inactive: siteInactiveCount,
//                   icon: Icons.location_on_rounded,
//                   color: Colors.indigo,
//                 ),
//                 _buildStatCard(
//                   title: "Projects",
//                   total: projectCount,
//                   active: projectActiveCount,
//                   inactive: projectInactiveCount,
//                   icon: Icons.engineering_rounded,
//                   color: Colors.teal,
//                 ),
//                 _buildStatCard(
//                   title: "Supervisors",
//                   total: supervisorCount,
//                   active: supervisorActiveCount,
//                   inactive: supervisorInactiveCount,
//                   icon: Icons.supervisor_account_rounded,
//                   color: Colors.deepPurple,
//                 ),
//                 _buildStatCard(
//                   title: "Employees",
//                   total: employeeCount,
//                   active: employeeActiveCount,
//                   inactive: employeeInactiveCount,
//                   icon: Icons.people_alt_rounded,
//                   color: Colors.orange,
//                 ),
//                 _buildStatCard(
//                   title: "Allocations",
//                   total: allocationCount,
//                   active: allocationActiveCount,
//                   inactive: allocationInactiveCount,
//                   icon: Icons.assignment_turned_in_rounded,
//                   color: Colors.blueGrey,
//                 ),
//               ],
//             );
//           },
//         ),

//         const SizedBox(height: 24),

//         // 🟢 Bottom Section: Pie Chart + Profile
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(child: _buildPiechart(employeeTypeCount)),
//             const SizedBox(width: 16),
//             Expanded(child: Column(
//               children: [
//                 _buildProfileCard(),
//                   const SizedBox(height: 20),
               

//               ],
//             )),
//           ],
//         ),
//       ],
//     ),
//   );
// }


//   Widget _buildStatCard({
//     required String title,
//     required int total,
//     required int active,
//     required int inactive,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: 54,
//             width: 54,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(width: 18),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     color: Color(0xFF7B8A8C),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         total.toString(),
//                         style: TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                           color: color,
//                         ),
//                       ),
//                     ),
//                       Row(
//                                         children: [
//                                           Text(
//                       'Active: $active',
//                       style: const TextStyle(fontSize: 12, color: Colors.green),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           Text(
//                       'Inactive: $inactive',
//                       style: const TextStyle(fontSize: 12, color: Colors.red),
//                                           ),
//                                         ],
//                                       ),
//                   ],
//                 ),
              
              
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget _buildProfileCard() {
//   return Container(
//     height: 180,
//     padding: const EdgeInsets.all(24),
//     decoration: BoxDecoration(
//       gradient: const LinearGradient(
//         colors: [Color(0xFF0052D4), Color(0xFF4364F7), Color(0xFF6FB1FC)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.circular(24),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.blueGrey.withOpacity(0.2),
//           blurRadius: 18,
//           offset: const Offset(0, 8),
//         ),
//       ],
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Profile image with subtle border glow
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: const CircleAvatar(
//             radius: 45,
            
//           ),
//         ),

//         const SizedBox(width: 22),

//         // Profile Info
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Admin Profile",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 children: const [
//                   Icon(Icons.badge, color: Colors.white70, size: 18),
//                   SizedBox(width: 6),
//                   Text(
//                     "Administrator",
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.white70,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: const [
//                   Icon(Icons.email_outlined, color: Colors.white70, size: 18),
//                   SizedBox(width: 6),
//                   Text(
//                     "admin@company.com",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
              
//             ],
//           ),
//         ),

//         // Edit Button
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           padding: const EdgeInsets.all(10),
//           child: const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
//         ),
//       ],
//     ),
//   );
// }


// Widget _buildPiechart(Map<String, int> employeeTypeCount) {
//   final total = employeeTypeCount.values.fold(0, (a, b) => a + b);

//   if (total == 0) {
//     return Container(
//       height: 400,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 10,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: const Center(
//         child: Text(
//           "No Employee Data Available",
//           style: TextStyle(color: Colors.grey, fontSize: 14),
//         ),
//       ),
//     );
//   }

//   final colors = {
//     "Permanent": Colors.blueAccent,
//     "Temporary": Colors.orangeAccent,
//     "Contract": Colors.teal,
//   };

//   return Container(
//     height: 400,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(22),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.15),
//           blurRadius: 10,
//           offset: const Offset(0, 6),
//         ),
//       ],
//     ),
//     padding: const EdgeInsets.all(16),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Employee Type Distribution",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Expanded(
//           child: PieChart(
//             PieChartData(
//               centerSpaceRadius: 0,
//               sectionsSpace: 3,
//               sections: employeeTypeCount.entries
//                   .where((entry) => entry.value > 0)
//                   .map((entry) {
//                 final percentage =
//                     ((entry.value / total) * 100).toStringAsFixed(1);
//                 return PieChartSectionData(
//                   color: colors[entry.key] ?? Colors.grey,
//                   value: entry.value.toDouble(),
//                   title: "${entry.key}\n$percentage%",
//                   titleStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   radius: 150,
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: employeeTypeCount.keys.map((key) {
//             final color = colors[key]!;
//             final count = employeeTypeCount[key]!;
//             return Row(
//               children: [
//                 CircleAvatar(radius: 6, backgroundColor: color),
//                 const SizedBox(width: 6),
//                 Text(
//                   "$key ($count)",
//                   style: const TextStyle(fontSize: 13),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ],
//     ),
//   );
// }


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc/allocation/allocation_bloc.dart';
import '../../bloc/bloc/employee/employee_bloc.dart';
import '../../bloc/bloc/projectmaster/project_bloc.dart';
import '../../bloc/bloc/site/site_bloc.dart';
import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
import '../../bloc/event/allocation/allocation_event.dart';
import '../../bloc/event/employee/employee_event.dart';
import '../../bloc/event/projectmaster/project_event.dart';
import '../../bloc/event/site/site_event.dart';
import '../../bloc/event/supervisor/supervisor_event.dart';
import '../../bloc/state/allocation/allocation_state.dart';
import '../../bloc/state/employee/employee_state.dart';
import '../../bloc/state/projectmaster/project_state.dart';
import '../../bloc/state/site/site_state.dart';
import '../../bloc/state/supervisor/supervisor_state.dart';
import '../../constant/app_color.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int siteCount = 0;
  int siteActiveCount = 0;
  int siteInactiveCount = 0;

  int projectCount = 0;
  int projectActiveCount = 0;
  int projectInactiveCount = 0;

  int supervisorCount = 0;
  int supervisorActiveCount = 0;
  int supervisorInactiveCount = 0;

  int employeeCount = 0;
  int employeeActiveCount = 0;
  int employeeInactiveCount = 0;

  int allocationCount = 0;
  int allocationActiveCount = 0;
  int allocationInactiveCount = 0;

  Map<String, int> employeeTypeCount = {
    "Permanent": 0,
    "Temporary": 0,
    "Contract": 0,
  };

  // 🟢 Added: for monthly allocation chart
  List<Map<String, dynamic>> monthlyAllocationData = [];
  

  @override
  void initState() {
    super.initState();
    context.read<SiteBloc>().add(FetchSiteEvent());
    context.read<ProjectBloc>().add(FetchProjectEvent());
    context.read<SupervisorBloc>().add(FetchSupervisorsEvent());
    context.read<EmployeeBloc>().add(FetchEmployeeEvent());
    context.read<AllocationBloc>().add(FetchAllocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: MultiBlocListener(
            listeners: [
              BlocListener<SiteBloc, SiteState>(
                listener: (context, state) {
                  if (state is SiteLoaded) {
                    setState(() {
                      siteCount = state.site.length;
                      siteActiveCount =
                          state.site.where((s) => s.status == "Active").length;
                      siteInactiveCount =
                          state.site.where((s) => s.status == "Inactive").length;
                    });
                  }
                },
              ),
              BlocListener<ProjectBloc, ProjectState>(
                listener: (context, state) {
                  if (state is ProjectLoaded) {
                    setState(() {
                      projectCount = state.project.length;
                      projectActiveCount =
                          state.project.where((p) => p.status == "Active").length;
                      projectInactiveCount =
                          state.project.where((p) => p.status == "Inactive").length;
                    });
                  }
                },
              ),
              BlocListener<SupervisorBloc, SupervisorState>(
                listener: (context, state) {
                  if (state is SupervisorLoaded) {
                    setState(() {
                      supervisorCount = state.supervisors.length;
                      supervisorActiveCount = state.supervisors
                          .where((s) => s.status == "Active")
                          .length;
                      supervisorInactiveCount = state.supervisors
                          .where((s) => s.status == "Inactive")
                          .length;
                    });
                  }
                },
              ),
              BlocListener<EmployeeBloc, EmployeeState>(
                listener: (context, state) {
                  if (state is EmployeeLoaded) {
                    setState(() {
                      employeeCount = state.employee.length;
                      employeeActiveCount = state.employee
                          .where((e) => e.status == "Active")
                          .length;
                      employeeInactiveCount = state.employee
                          .where((e) => e.status == "Inactive")
                          .length;

                      employeeTypeCount = {
                        "Permanent": 0,
                        "Temporary": 0,
                        "Contract": 0,
                      };

                      for (var emp in state.employee) {
                        final type = emp.type?.trim() ?? "";
                        if (employeeTypeCount.containsKey(type)) {
                          employeeTypeCount[type] =
                              employeeTypeCount[type]! + 1;
                        } else {
                          employeeTypeCount["Temporary"] =
                              (employeeTypeCount["Temporary"] ?? 0) + 1;
                        }
                      }
                    });
                  }
                },
              ),
              BlocListener<AllocationBloc, AllocationState>(
                listener: (context, state) {
                  if (state is AllocationLoaded) {
                    // 🔹 Calculate active/inactive counts
                    allocationCount = state.allocation.length;
                    allocationActiveCount = state.allocation
                        .where((a) => a.status == "Active")
                        .length;
                    allocationInactiveCount = state.allocation
                        .where((a) => a.status == "Inactive")
                        .length;

                    // 🔹 Prepare monthly allocation data
                    final monthlyMap = <String, int>{
                      "Jan": 0,
                      "Feb": 0,
                      "Mar": 0,
                      "Apr": 0,
                      "May": 0,
                      "Jun": 0,
                      "Jul": 0,
                      "Aug": 0,
                      "Sep": 0,
                      "Oct": 0,
                      "Nov": 0,
                      "Dec": 0,
                    };

                    for (var alloc in state.allocation) {
                      if (alloc.createdAt != null) {
                        try {
                          final date = DateTime.parse(alloc.createdAt.toString()!);
                          final monthName = [
                            "Jan",
                            "Feb",
                            "Mar",
                            "Apr",
                            "May",
                            "Jun",
                            "Jul",
                            "Aug",
                            "Sep",
                            "Oct",
                            "Nov",
                            "Dec"
                          ][date.month - 1];
                          monthlyMap[monthName] =
                              (monthlyMap[monthName] ?? 0) + 1;
                        } catch (e) {
                          // ignore parse errors
                        }
                      }
                    }

                    setState(() {
                      monthlyAllocationData = monthlyMap.entries
                          .map((e) => {"month": e.key, "count": e.value})
                          .toList();
                    });
                  }
                },
              ),
            ],
            child: _buildDashboardUI(),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth < 700 ? 2 : 3;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _buildStatCard(
                    title: "Sites",
                    total: siteCount,
                    active: siteActiveCount,
                    inactive: siteInactiveCount,
                    icon: Icons.location_on_rounded,
                    color: Colors.indigo,
                  ),
                  _buildStatCard(
                    title: "Projects",
                    total: projectCount,
                    active: projectActiveCount,
                    inactive: projectInactiveCount,
                    icon: Icons.engineering_rounded,
                    color: Colors.teal,
                  ),
                  _buildStatCard(
                    title: "Supervisors",
                    total: supervisorCount,
                    active: supervisorActiveCount,
                    inactive: supervisorInactiveCount,
                    icon: Icons.supervisor_account_rounded,
                    color: Colors.deepPurple,
                  ),
                  _buildStatCard(
                    title: "Employees",
                    total: employeeCount,
                    active: employeeActiveCount,
                    inactive: employeeInactiveCount,
                    icon: Icons.people_alt_rounded,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    title: "Allocations",
                    total: allocationCount,
                    active: allocationActiveCount,
                    inactive: allocationInactiveCount,
                    icon: Icons.assignment_turned_in_rounded,
                    color: Colors.blueGrey,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPiechart(employeeTypeCount)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 20),
                    _buildAllocationreport(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int total,
    required int active,
    required int inactive,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF7B8A8C),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        total.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ),
                    Row(
                      children: [
                        Text('Active: $active',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.green)),
                        const SizedBox(width: 10),
                        Text('Inactive: $inactive',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052D4), Color(0xFF4364F7), Color(0xFF6FB1FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 45),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Admin Profile",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.badge, color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text("Administrator",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.email_outlined,
                        color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text("admin@company.com",
                        style: TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child:
                const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildPiechart(Map<String, int> employeeTypeCount) {
    final total = employeeTypeCount.values.fold(0, (a, b) => a + b);

    if (total == 0) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text("No Employee Data Available",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      );
    }

    final colors = {
      "Permanent": Colors.blueAccent,
      "Temporary": Colors.orangeAccent,
      "Contract": Colors.teal,
    };

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Employee Type Distribution",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sectionsSpace: 3,
                sections: employeeTypeCount.entries
                    .where((entry) => entry.value > 0)
                    .map((entry) {
                  final percentage =
                      ((entry.value / total) * 100).toStringAsFixed(1);
                  return PieChartSectionData(
                    color: colors[entry.key] ?? Colors.grey,
                    value: entry.value.toDouble(),
                    title: "${entry.key}\n$percentage%",
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    radius: 150,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: employeeTypeCount.keys.map((key) {
              final color = colors[key]!;
              final count = employeeTypeCount[key]!;
              return Row(
                children: [
                  CircleAvatar(radius: 6, backgroundColor: color),
                  const SizedBox(width: 6),
                  Text("$key ($count)",
                      style: const TextStyle(fontSize: 13)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
Widget _buildAllocationreport() {
  final data = monthlyAllocationData.isEmpty
      ? [
          {"month": "Jan", "count": 0},
          {"month": "Feb", "count": 0},
          {"month": "Mar", "count": 0},
          {"month": "Apr", "count": 0},
          {"month": "May", "count": 0},
          {"month": "Jun", "count": 0},
          {"month": "Jul", "count": 0},
          {"month": "Aug", "count": 0},
          {"month": "Sep", "count": 0},
          {"month": "Oct", "count": 0},
          {"month": "Nov", "count": 0},
          {"month": "Dec", "count": 0},
        ]
      : monthlyAllocationData;

  final maxYValue =
      data.map((e) => e["count"] as int).reduce((a, b) => a > b ? a : b).toDouble();

  final safeMax = maxYValue == 0 ? 10.0 : maxYValue;
  final stepSize = (safeMax / 5).ceilToDouble().clamp(1, double.infinity).toDouble();

  return Container(
    height: 300,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Monthly Allocation Report",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: StatefulBuilder(
            builder: (context, setState) {
              int? touchedIndex;

              return BarChart(
                BarChartData(
                  maxY: safeMax + stepSize,
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: stepSize.toDouble(),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            return Text(
                              data[index]["month"],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: stepSize.toDouble(),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),

                  // ✅ Touch + tooltip setup
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                       
                        final value = rod.toY.toInt();
                        return BarTooltipItem(
                          "$value",
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          response != null &&
                          response.spot != null) {
                        setState(() {
                          touchedIndex = response.spot!.touchedBarGroupIndex;
                        });
                      } else {
                        setState(() {
                          touchedIndex = -1;
                        });
                      }
                    },
                  ),

                  // ✅ Bars with color change on touch
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final count = item["count"] as int;

                    final isTouched = index == touchedIndex;
                    final barColor =
                        isTouched ? Colors.orangeAccent : AppColor.primary;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: barColor,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

}