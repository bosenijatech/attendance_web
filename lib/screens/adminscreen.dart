// import 'package:attendance_web/screens/projectallocation/addprojectallication.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../model/supervisor/getallsupervisormodel.dart';
// import 'employeemaster/editemployeescreen.dart';
// import 'projectmaster/editprojectmasterscreen.dart';
// import 'sitemaster/editsitemasterscreen.dart';
// import 'sitemaster/sitemasterscreen.dart';
// import 'dashboard/dashboardscreen.dart';
// import 'employeemaster/employeemaster.dart';
// import 'projectallocation/projectallocation.dart';
// import 'projectmaster/projectmaster.dart';
// import 'supervisormaster/editsupervisorscreen.dart';
// import 'supervisormaster/supervisormaster.dart';
// import '../../constant/app_assets.dart';
// import '../../constant/app_color.dart';

// class AdminScreen extends StatefulWidget {
//   final int notificationCount;
//   const AdminScreen({super.key, this.notificationCount = 0});

//   @override
//   State<AdminScreen> createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   int selectedIndex = 0;
//   int hoveredIndex = -1;
// List<Supervisorlist> supervisorList = []; // <-- stores all supervisors
//   final List<String> menuItems = [
//     "Dashboard",
//     "Site Master",
//     "Project Master",
//     "Supervisor Master",
//     "Employee Master",
//     "Project Allocation",
//   ];

//   final List<String> menuIcons = [
//     AppAssets.dashboard,
//     AppAssets.sitemaster,
//     AppAssets.project,
//     AppAssets.supervisor,
//     AppAssets.employee,
//     AppAssets.allocation,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       const DashboardScreen(),
//       Sitemasterscreen(
//         onAdd: () => setState(() => selectedIndex = 6), // Add Site Master
//         onEdit: () => setState(() => selectedIndex = 7), // Edit Site Master
//       ),
//       ProjectmasterScreen(
//         onAdd: () => setState(() => selectedIndex = 8), // Add Project Master
//         onEdit: () => setState(() => selectedIndex = 9), // Edit Project Master
//       ),
//        SupervisormasterScreen(
//          onAdd: () => setState(() => selectedIndex = 10), // Add Supervisor Master
//         onEdit: () => setState(() => selectedIndex = 11), // Edit Supervisor Master
//        ),
//        EmployeemasterScreen(
//           onAdd: () => setState(() => selectedIndex = 12), // Add  Employee Master
//         onEdit: () => setState(() => selectedIndex = 13), // Edit  Employee Master
//        ),
//        ProjectallocationScreen(
//           onAdd: () => setState(() => selectedIndex = 14), // Add  Employee Master
//             onEdit: () => setState(() => selectedIndex = 15), isEdit: false, // Edit  Employee Master
//        ),
//       Editsitemasterscreen(
//         isEdit: false,
//         onBack: () => setState(() => selectedIndex = 1),
//         onAdd: (newSite) {},
//         onSave: (updatedSite) {},
//       ), 

//       Editprojectmasterscreen(
//         isEdit: false,
//         onBack: () => setState(() => selectedIndex = 2),
//         onAdd: (newProject) {},
//         onSave: (updatedProject) {},
//       ), 
//     Editsupervisorscreen(
//   isEdit: false,
//   allSupervisors: supervisorList, // <-- pass current list
//   onBack: () => setState(() => selectedIndex = 3),
//   onAdd: (newSupervisor) {
//     setState(() {
//       supervisorList.add(newSupervisor); // add to list
//       selectedIndex = 3; // go back to Supervisor Master page
//     });
//   },
//   onSave: (updatedSupervisor) {},
// ),
//       Editemployeescreen(
//         isEdit: false,
//         onBack: () => setState(() => selectedIndex = 4),
//         onAdd: (newEmployee) {},
//         onSave: (updatedEmployee) {},
//       ), 
//       Addprojectallicationscreen(
//         isEdit: false,
//         onBack: () => setState(() => selectedIndex =  5),
//         onAdd: (newAllocation) {},
//         onSave: (updatedAllocation) {},
//       ), 
    
//     ];

//     return Scaffold(
//       backgroundColor: AppColor.primaryLight,
//       body: Row(
//         children: [
//           // Sidebar
//           Container(
//             width: 260,
//             color: AppColor.white,
//             child: Column(
//               children: [
//                 const SizedBox(height: 30),
//                 Image.asset(AppAssets.logo, scale: 12),
//                 const SizedBox(height: 50),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: menuItems.length,
//                     itemBuilder: (context, index) {
//                       bool isSelected =
//                           selectedIndex == index ||
//                           (selectedIndex >= 6 &&
//                               index == 1); // treat Add/Edit as Site Master
//                       bool isHovered = hoveredIndex == index;

//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 5,
//                         ),
//                         child: MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 selectedIndex = index;
//                               });
//                             },
//                             onHover: (hovering) {
//                               setState(() {
//                                 hoveredIndex = hovering ? index : -1;
//                               });
//                             },
//                             mouseCursor: SystemMouseCursors.click,
//                             borderRadius: BorderRadius.circular(8),
//                             child: MouseRegion(
//                               cursor: SystemMouseCursors.click,
//                               child: AnimatedContainer(
//                                 duration: const Duration(milliseconds: 200),
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? AppColor.primary
//                                       : isHovered
//                                       ? Colors.blueGrey.shade100
//                                       : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: MouseRegion(
//                                   cursor: SystemMouseCursors.click,
//                                   child: ListTile(
//                                     leading: MouseRegion(
//                                          cursor: SystemMouseCursors.click,
//                                       child: SvgPicture.asset(
                                        
//                                         menuIcons[index],
//                                         color: isSelected
//                                             ? Colors.white
//                                             : AppColor.bluishGrey,
//                                         width: 24,
//                                         height: 24,
//                                       ),
//                                     ),
//                                     title: MouseRegion(
//                                       cursor: SystemMouseCursors.click,
//                                       child: Text(
//                                         menuItems[index],
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                           color: isSelected
//                                               ? Colors.white
//                                               : AppColor.bluishGrey,
//                                           fontWeight: isSelected
//                                               ? FontWeight.bold
//                                               : FontWeight.normal,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Main Content
//           Expanded(
//             child: Column(
//               children: [
//                 const SizedBox(height: 24),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         height: 40,
//                         width: 700,
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         color: AppColor.white,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               selectedIndex == 6
//                                   ? "Add Site Master"
//                                   : selectedIndex == 7
//                                   ? "Edit Site Master"
//                                   : selectedIndex == 8
//                                   ? "Add Project Master"
//                                   : selectedIndex == 9
//                                   ? "Edit Project Master"
//                                    : selectedIndex == 10
//                                   ? "Add Super Master"
//                                   : selectedIndex == 11
//                                   ? "Edit Project Master"
//                                   : menuItems[selectedIndex],

//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 color: AppColor.primary,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               MouseRegion(
//                                 cursor: SystemMouseCursors.click,
//                                 child: Container(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Center(
//                                     child: SvgPicture.asset(
//                                       AppAssets.bell,
//                                       color: AppColor.navyBlue,
//                                       width: 18,
//                                       height: 18,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               if (widget.notificationCount > 0)
//                                 Positioned(
//                                   top: -5,
//                                   right: -5,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(6),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: Colors.white,
//                                         width: 2,
//                                       ),
//                                     ),
//                                     child: Text(
//                                       widget.notificationCount.toString(),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(width: 20),
//                           MouseRegion(
//                             cursor: SystemMouseCursors.click,
//                             child: const CircleAvatar(
//                               backgroundColor: Colors.blue,
//                               child: Icon(Icons.person, color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Dynamic Page Content
//                 Expanded(child: pages[selectedIndex]),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:attendance_web/screens/projectallocation/addprojectallication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/supervisor/getallsupervisormodel.dart';
import 'employeemaster/editemployeescreen.dart';
import 'projectmaster/editprojectmasterscreen.dart';
import 'sitemaster/editsitemasterscreen.dart';
import 'sitemaster/sitemasterscreen.dart';
import 'dashboard/dashboardscreen.dart';
import 'employeemaster/employeemaster.dart';
import 'projectallocation/projectallocation.dart';
import 'projectmaster/projectmaster.dart';
import 'supervisormaster/editsupervisorscreen.dart';
import 'supervisormaster/supervisormaster.dart';
import '../../constant/app_assets.dart';
import '../../constant/app_color.dart';

class AdminScreen extends StatefulWidget {
  final int notificationCount;
  const AdminScreen({super.key, this.notificationCount = 0});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int selectedIndex = 0;
  int hoveredIndex = -1;

  // Supervisor list for master screen
  List<Supervisorlist> supervisorList = [];

  final List<String> menuItems = [
    "Dashboard",
    "Site Master",
    "Project Master",
    "Supervisor Master",
    "Employee Master",
    "Project Allocation",
  ];

  final List<String> menuIcons = [
    AppAssets.dashboard,
    AppAssets.sitemaster,
    AppAssets.project,
    AppAssets.supervisor,
    AppAssets.employee,
    AppAssets.allocation,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: AppColor.white,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(AppAssets.logo, scale: 12),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      bool isSelected =
                          selectedIndex == index ||
                          (selectedIndex >= 6 &&
                              index == 1); // treat Add/Edit as Site Master
                      bool isHovered = hoveredIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            onHover: (hovering) {
                              setState(() {
                                hoveredIndex = hovering ? index : -1;
                              });
                            },
                            mouseCursor: SystemMouseCursors.click,
                            borderRadius: BorderRadius.circular(8),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColor.primary
                                      : isHovered
                                          ? Colors.blueGrey.shade100
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: ListTile(
                                    leading: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: SvgPicture.asset(
                                        menuIcons[index],
                                        color: isSelected
                                            ? Colors.white
                                            : AppColor.bluishGrey,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    title: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Text(
                                        menuItems[index],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColor.bluishGrey,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 700,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: AppColor.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedIndex == 6
                                  ? "Add Site Master"
                                  : selectedIndex == 7
                                      ? "Edit Site Master"
                                      : selectedIndex == 8
                                          ? "Add Project Master"
                                          : selectedIndex == 9
                                              ? "Edit Project Master"
                                              : selectedIndex == 10
                                                  ? "Add Supervisor Master"
                                                  : selectedIndex == 11
                                                      ? "Edit Supervisor Master"
                                                      : menuItems[selectedIndex],
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppAssets.bell,
                                      color: AppColor.navyBlue,
                                      width: 18,
                                      height: 18,
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.notificationCount > 0)
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      widget.notificationCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Dynamic Page Content
                Expanded(
                  child: Builder(builder: (context) {
                    switch (selectedIndex) {
                      case 0:
                        return const DashboardScreen();
                      case 1:
                        return Sitemasterscreen(
                          onAdd: () => setState(() => selectedIndex = 6),
                          onEdit: () => setState(() => selectedIndex = 7),
                        );
                      case 2:
                        return ProjectmasterScreen(
                          onAdd: () => setState(() => selectedIndex = 8),
                          onEdit: () => setState(() => selectedIndex = 9),
                        );
                      case 3:
                        return SupervisormasterScreen(
                          supervisors: supervisorList,
                          onAdd: () => setState(() => selectedIndex = 10),
                          onEdit: () => setState(() => selectedIndex = 11),
                        );
                      case 4:
                        return EmployeemasterScreen(
                          onAdd: () => setState(() => selectedIndex = 12),
                          onEdit: () => setState(() => selectedIndex = 13),
                        );
                      case 5:
                        return ProjectallocationScreen(
                          onAdd: () => setState(() => selectedIndex = 14),
                          onEdit: () => setState(() => selectedIndex = 15),
                          isEdit: false,
                        );
                      case 6:
                        return Editsitemasterscreen(
                          isEdit: false,
                          onBack: () => setState(() => selectedIndex = 1),
                          onAdd: (newSite) {},
                          onSave: (updatedSite) {},
                        );
                      case 7:
                        return Editprojectmasterscreen(
                          isEdit: false,
                          onBack: () => setState(() => selectedIndex = 2),
                          onAdd: (newProject) {},
                          onSave: (updatedProject) {},
                        );
                      case 10:
                        return Editsupervisorscreen(
                          isEdit: false,
                          allSupervisors: supervisorList,
                          onBack: () => setState(() => selectedIndex = 3),
                          onAdd: (newSupervisor) {
                            setState(() {
                              supervisorList.add(newSupervisor);
                              selectedIndex = 3;
                            });
                          },
                          onSave: (updatedSupervisor) {},
                        );
                      case 12:
                        return Editemployeescreen(
                          isEdit: false,
                          onBack: () => setState(() => selectedIndex = 4),
                          onAdd: (newEmployee) {},
                          onSave: (updatedEmployee) {},
                        );
                      case 14:
                        return Addprojectallicationscreen(
                          isEdit: false,
                          onBack: () => setState(() => selectedIndex = 5),
                          onAdd: (newAllocation) {},
                          onSave: (updatedAllocation) {},
                        );
                      default:
                        return Container();
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
