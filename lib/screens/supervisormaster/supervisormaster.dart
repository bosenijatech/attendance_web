// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import '../../constant/app_color.dart';
// // import '../../constant/app_assets.dart';
// // import '../../model/supervisor/getallsupervisormodel.dart';
// // import '../../services/attendance_apiservice.dart';
// // import 'editsupervisorscreen.dart';

// // class SupervisormasterScreen extends StatefulWidget {
// //   const SupervisormasterScreen({
// //     super.key,
// //     required void Function() onAdd,
// //     required void Function() onEdit,
// //   });

// //   @override
// //   State<SupervisormasterScreen> createState() => _SupervisormasterScreenState();
// // }

// // class _SupervisormasterScreenState extends State<SupervisormasterScreen> {
// //   final AttendanceApiService apiService = AttendanceApiService();
// //   bool isLoading = false;
// //   String currentView = "list"; // "list" | "add" | "edit"
// //   Supervisorlist? selectedSupervisor;

// //   List<Supervisorlist> supervisorListPage = [];
// //   int currentPage = 1;
// //   final int supervisorPerPage = 7;

// //   @override
// //   void initState() {
// //     super.initState();
// //     getAllSupervisor();
// //   }

// //   // ✅ API call
// //   Future<void> getAllSupervisor() async {
// //     setState(() {
// //       isLoading = true;
// //     });

// //     try {
// //       var result = await apiService.getAllSupervisor();
// //       var response = GetallsupervisorsModel.fromJson(result);

// //       if (response.status == true) {
// //         setState(() {
// //           supervisorListPage = response.data ?? [];
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           supervisorListPage = [];
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         supervisorListPage = [];
// //         isLoading = false;
// //       });
// //       print("❌ Error: $e");
// //     }
// //   }

// //   // Pagination helper
// //   List<int> getVisiblePages(int totalPages) {
// //     List<int> pages = [];
// //     if (totalPages <= 5) {
// //       for (int i = 1; i <= totalPages; i++) pages.add(i);
// //     } else {
// //       if (currentPage <= 3) {
// //         pages.addAll([1, 2, 3, -1, totalPages]);
// //       } else if (currentPage >= totalPages - 2) {
// //         pages.addAll([1, -1, totalPages - 2, totalPages - 1, totalPages]);
// //       } else {
// //         pages.addAll([
// //           1,
// //           -1,
// //           currentPage - 1,
// //           currentPage,
// //           currentPage + 1,
// //           -1,
// //           totalPages,
// //         ]);
// //       }
// //     }
// //     return pages;
// //   }

// //   @override
// //   Widget build(BuildContext context) {

// //         // ===== If Add Page =====
// //     if (currentView == "add") {
// //       return Editsupervisorscreen(
// //         isEdit: false,
// //         onBack: () => setState(() => currentView = "list"),
// //         onAdd: (newSupervisor) {
// //           setState(() {
// //             newSupervisor.id = supervisor.length + 1;
// //             supervisor.add(newSupervisor);
// //             currentView = "list";
// //           });
// //         }, onSave: (updatedSupervisor) {  },
// //       );
// //     }

// //     // ===== If Edit Page =====
// //     if (currentView == "edit" && selectedSupervisor!= null) {
// //       return Editsupervisorscreen(
// //         isEdit: true,
// //         supervisor: selectedSupervisor,
// //         onBack: () => setState(() {
// //           currentView = "list";
// //           selectedSupervisor = null;
// //         }),
// //         onSave: (updatedSupervisor) {
// //           setState(() {
// //             int index = upervisor.indexWhere((s) => s.id == updatedSupervisor.id);
// //             if (index != -1) supervisor[index] = updatedSupervisor;
// //             currentView = "list";
// //           });
// //         }, onAdd: (newSupervisor) {  },
// //       );
// //     }
// //     int totalPages = (supervisorListPage.length / supervisorPerPage).ceil();
// //     if (totalPages == 0) totalPages = 1;

// //     int start = (currentPage - 1) * supervisorPerPage;
// //     int end = (start + supervisorPerPage > supervisorListPage.length)
// //         ? supervisorListPage.length
// //         : start + supervisorPerPage;
// //     List<Supervisorlist> currentSupervisor =
// //         supervisorListPage.sublist(start, end);

// //     return Scaffold(
// //       backgroundColor: AppColor.primaryLight,
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
// //         child: Column(
// //           children: [
// //             // 🔍 Search + Filter + Add
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Container(
// //                     height: 40,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(color: Colors.grey.shade300, width: 1),
// //                     ),
// //                     padding: const EdgeInsets.symmetric(horizontal: 8),
// //                     child: const Center(
// //                       child: TextField(
// //                         textAlignVertical: TextAlignVertical.center,
// //                         decoration: InputDecoration(
// //                           hintText: "Search...",
// //                           border: InputBorder.none,
// //                           isDense: true,
// //                           contentPadding:
// //                               EdgeInsets.symmetric(vertical: 0, horizontal: 12),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Container(
// //                   height: 40,
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: TextButton.icon(
// //                     onPressed: () {
// //                       // TODO filter
// //                     },
// //                     icon: const Icon(Icons.filter_list, color: Colors.black),
// //                     label: const Text("Filter",
// //                         style: TextStyle(color: Colors.black)),
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 Container(
// //                   height: 40,
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(
// //                     color: AppColor.primary,
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: TextButton.icon(
// //                     onPressed: () {
// //                       setState(() => currentView = "add");
// //                     },
// //                     icon: const Icon(Icons.add, color: Colors.white),
// //                     label: const Text("Add Supervisor Master",
// //                         style: TextStyle(color: Colors.white)),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 20),

// //             // 📊 Table
// //             Expanded(
// //               child: isLoading
// //                   ? const Center(child: CircularProgressIndicator())
// //                   : currentSupervisor.isEmpty
// //                       ? const Center(child: Text("No Supervisors Found"))
// //                       : LayoutBuilder(
// //                           builder: (context, constraints) {
// //                             return SingleChildScrollView(
// //                               physics: const NeverScrollableScrollPhysics(),
// //                               child: ConstrainedBox(
// //                                 constraints:
// //                                     BoxConstraints(minWidth: constraints.maxWidth),
// //                                 child: DataTable(
// //                                   headingRowColor: MaterialStateProperty.all(
// //                                       AppColor.primaryLight),
// //                                   columnSpacing: 120,
// //                                   columns: const [
// //                                     DataColumn(
// //                                         label: Text('Supervisor ID',
// //                                             style: TextStyle(
// //                                                 fontWeight: FontWeight.bold))),
// //                                     DataColumn(
// //                                         label: Text('Supervisor Name',
// //                                             style: TextStyle(
// //                                                 fontWeight: FontWeight.bold))),
// //                                     DataColumn(
// //                                         label: Text('Type',
// //                                             style: TextStyle(
// //                                                 fontWeight: FontWeight.bold))),
// //                                     DataColumn(
// //                                         label: Text('Status',
// //                                             style: TextStyle(
// //                                                 fontWeight: FontWeight.bold))),
// //                                     DataColumn(
// //                                         label: Text('Action',
// //                                             style: TextStyle(
// //                                                 fontWeight: FontWeight.bold))),
// //                                   ],
// //                                   rows: currentSupervisor.map((supervisor) {
// //                                     return DataRow(
// //                                       cells: [
// //                                         DataCell(Text(
// //                                             'S${supervisor.supervisorid.toString().padLeft(4, '0')}')),
// //                                         DataCell(Text(
// //                                             supervisor.supervisorname ?? "")),
// //                                         DataCell(Text(supervisor.type ?? "")),
// //                                         DataCell(
// //                                           Text(
// //                                             supervisor.status ?? "",
// //                                             style: TextStyle(
// //                                               color: (supervisor.status == "Active")
// //                                                   ? Colors.green[800]
// //                                                   : Colors.red[800],
// //                                               fontWeight: FontWeight.bold,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                         DataCell(
// //                                           InkWell(
// //                                             onTap: () {
// //                                               setState(() {
// //                                                 selectedSupervisor = supervisor;
// //                                                 currentView = "edit";
// //                                               });
// //                                             },
// //                                             child: Image.asset(
// //                                               AppAssets.edit_icon,
// //                                               width: 16,
// //                                               height: 16,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     );
// //                                   }).toList(),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //             ),

// //             const SizedBox(height: 16),

// //             // ⏮ Pagination
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // Prev
// //                 MouseRegion(
// //                       cursor: SystemMouseCursors.click,
// //                   child: GestureDetector(
// //                     onTap: currentPage > 1
// //                         ? () => setState(() => currentPage--)
// //                         : null,
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 20, vertical: 10),
// //                       decoration: BoxDecoration(
// //                         color: currentPage > 1
// //                             ? AppColor.primary
// //                             : Colors.grey[300],
// //                         borderRadius: BorderRadius.circular(50),
// //                       ),
// //                       child: Text("Previous",
// //                           style: TextStyle(
// //                               color: currentPage > 1
// //                                   ? Colors.white
// //                                   : Colors.black)),
// //                     ),
// //                   ),
// //                 ),
// //                 // Pages
// //                 Row(
// //                   children: getVisiblePages(totalPages).map((page) {
// //                     if (page == -1) {
// //                       return const Padding(
// //                         padding: EdgeInsets.symmetric(horizontal: 6),
// //                         child: Text("..."),
// //                       );
// //                     }
// //                     return MouseRegion(
// //                       cursor: SystemMouseCursors.click,
// //                       child: GestureDetector(
// //                         onTap: () => setState(() => currentPage = page),
// //                         child: Container(
// //                           margin: const EdgeInsets.symmetric(horizontal: 4),
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 14, vertical: 8),
// //                           decoration: BoxDecoration(
// //                             color: page == currentPage
// //                                 ? AppColor.primary
// //                                 : Colors.grey[300],
// //                             borderRadius: BorderRadius.circular(50),
// //                           ),
// //                           child: Text(
// //                             "$page",
// //                             style: TextStyle(
// //                                 color: page == currentPage
// //                                     ? Colors.white
// //                                     : Colors.black,
// //                                 fontWeight: FontWeight.bold),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //                 // Next
// //                 MouseRegion(
// //                       cursor: SystemMouseCursors.click,
// //                   child: GestureDetector(
// //                     onTap: currentPage < totalPages
// //                         ? () => setState(() => currentPage++)
// //                         : null,
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 20, vertical: 10),
// //                       decoration: BoxDecoration(
// //                         color: currentPage < totalPages
// //                             ? AppColor.primary
// //                             : Colors.grey[300],
// //                         borderRadius: BorderRadius.circular(50),
// //                       ),
// //                       child: Text("Next",
// //                           style: TextStyle(
// //                               color: currentPage < totalPages
// //                                   ? Colors.white
// //                                   : Colors.black)),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../constant/app_color.dart';
// import '../../constant/app_assets.dart';
// import '../../model/supervisor/getallsupervisormodel.dart';
// import '../../services/attendance_apiservice.dart';
// import 'editsupervisorscreen.dart';

// class SupervisormasterScreen extends StatefulWidget {
//   const SupervisormasterScreen({
//     super.key,
//     required void Function() onAdd,
//     required void Function() onEdit, required List<Supervisorlist> supervisors,
//   });

//   @override
//   State<SupervisormasterScreen> createState() => _SupervisormasterScreenState();
// }

// class _SupervisormasterScreenState extends State<SupervisormasterScreen> {
//   final AttendanceApiService apiService = AttendanceApiService();
//   bool isLoading = false;
//   String currentView = "list"; // "list" | "add" | "edit"
//   Supervisorlist? selectedSupervisor;

//   List<Supervisorlist> supervisorListPage = [];
//   int currentPage = 1;
//   final int supervisorPerPage = 7;

//   @override
//   void initState() {
//     super.initState();
//     getAllSupervisor();
//   }

//   // ✅ API call
//   Future<void> getAllSupervisor() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await apiService.getAllSupervisor();
//       var response = GetallsupervisorsModel.fromJson(result);

//       if (response.status == true) {
//         setState(() {
//           supervisorListPage = response.data ?? [];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           supervisorListPage = [];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         supervisorListPage = [];
//         isLoading = false;
//       });
//       print("❌ Error: $e");
//     }
//   }

//   // Pagination helper
//   List<int> getVisiblePages(int totalPages) {
//     List<int> pages = [];
//     if (totalPages <= 5) {
//       for (int i = 1; i <= totalPages; i++) pages.add(i);
//     } else {
//       if (currentPage <= 3) {
//         pages.addAll([1, 2, 3, -1, totalPages]);
//       } else if (currentPage >= totalPages - 2) {
//         pages.addAll([1, -1, totalPages - 2, totalPages - 1, totalPages]);
//       } else {
//         pages.addAll([
//           1,
//           -1,
//           currentPage - 1,
//           currentPage,
//           currentPage + 1,
//           -1,
//           totalPages,
//         ]);
//       }
//     }
//     return pages;
//   }

//   @override
//   Widget build(BuildContext context) {

//   // ===== If Add Page =====
// if (currentView == "add") {
//   return Editsupervisorscreen(
//     isEdit: false,
//     onBack: () => setState(() => currentView = "list"),
//     onAdd: (_) async {
//       // ✅ After add, refresh full list from API
//       await getAllSupervisor();
//       setState(() => currentView = "list");
//     },
//     onSave: (_) {},
//   );
// }

// // ===== If Edit Page =====
// if (currentView == "edit" && selectedSupervisor != null) {
//   return Editsupervisorscreen(
//     isEdit: true,
//     supervisor: selectedSupervisor,
//     onBack: () => setState(() {
//       currentView = "list";
//       selectedSupervisor = null;
//     }),
//     onSave: (_) async {
//       // ✅ After edit, refresh full list from API
//       await getAllSupervisor();
//       setState(() => currentView = "list");
//     },
//     onAdd: (_) {}, // not used in Edit mode
//   );
// }

//     int totalPages = (supervisorListPage.length / supervisorPerPage).ceil();
//     if (totalPages == 0) totalPages = 1;

//     int start = (currentPage - 1) * supervisorPerPage;
//     int end = (start + supervisorPerPage > supervisorListPage.length)
//         ? supervisorListPage.length
//         : start + supervisorPerPage;
//     List<Supervisorlist> currentSupervisor =
//         supervisorListPage.sublist(start, end);

//     return Scaffold(
//       backgroundColor: AppColor.primaryLight,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//         child: Column(
//           children: [
//             // 🔍 Search + Filter + Add
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: const Center(
//                       child: TextField(
//                         textAlignVertical: TextAlignVertical.center,
//                         decoration: InputDecoration(
//                           hintText: "Search...",
//                           border: InputBorder.none,
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(vertical: 0, horizontal: 12),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Container(
//                   height: 40,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: TextButton.icon(
//                     onPressed: () {
//                       // TODO filter
//                     },
//                     icon: const Icon(Icons.filter_list, color: Colors.black),
//                     label: const Text("Filter",
//                         style: TextStyle(color: Colors.black)),
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   height: 40,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: AppColor.primary,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: TextButton.icon(
//                     onPressed: () {
//                       setState(() => currentView = "add");
//                     },
//                     icon: const Icon(Icons.add, color: Colors.white),
//                     label: const Text("Add Supervisor Master",
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // 📊 Table
//             Expanded(
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : currentSupervisor.isEmpty
//                       ? const Center(child: Text("No Supervisors Found"))
//                       : LayoutBuilder(
//                           builder: (context, constraints) {
//                             return SingleChildScrollView(
//                               physics: const NeverScrollableScrollPhysics(),
//                               child: ConstrainedBox(
//                                 constraints:
//                                     BoxConstraints(minWidth: constraints.maxWidth),
//                                 child: DataTable(
//                                   headingRowColor: MaterialStateProperty.all(
//                                       AppColor.primaryLight),
//                                   columnSpacing: 120,
//                                   columns: const [
//                                     DataColumn(
//                                         label: Text('Supervisor ID',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                     DataColumn(
//                                         label: Text('Supervisor Name',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                     DataColumn(
//                                         label: Text('Type',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                     DataColumn(
//                                         label: Text('Status',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                     DataColumn(
//                                         label: Text('Action',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                   ],
//                                   rows: currentSupervisor.map((supervisor) {
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(Text(
//                                             'S${supervisor.supervisorid.toString().padLeft(4, '0')}')),
//                                         DataCell(Text(
//                                             supervisor.supervisorname ?? "")),
//                                         DataCell(Text(supervisor.type ?? "")),
//                                         DataCell(
//                                           Text(
//                                             supervisor.status ?? "",
//                                             style: TextStyle(
//                                               color: (supervisor.status == "Active")
//                                                   ? Colors.green[800]
//                                                   : Colors.red[800],
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                         DataCell(
//                                           InkWell(
//                                             onTap: () {
//                                               setState(() {
//                                                 selectedSupervisor = supervisor;
//                                                 currentView = "edit";
//                                               });
//                                             },
//                                             child: Image.asset(
//                                               AppAssets.edit_icon,
//                                               width: 16,
//                                               height: 16,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//             ),

//             const SizedBox(height: 16),

//             // ⏮ Pagination
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Prev
//                 MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                   child: GestureDetector(
//                     onTap: currentPage > 1
//                         ? () => setState(() => currentPage--)
//                         : null,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: currentPage > 1
//                             ? AppColor.primary
//                             : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Text("Previous",
//                           style: TextStyle(
//                               color: currentPage > 1
//                                   ? Colors.white
//                                   : Colors.black)),
//                     ),
//                   ),
//                 ),
//                 // Pages
//                 Row(
//                   children: getVisiblePages(totalPages).map((page) {
//                     if (page == -1) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 6),
//                         child: Text("..."),
//                       );
//                     }
//                     return MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                       child: GestureDetector(
//                         onTap: () => setState(() => currentPage = page),
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: page == currentPage
//                                 ? AppColor.primary
//                                 : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Text(
//                             "$page",
//                             style: TextStyle(
//                                 color: page == currentPage
//                                     ? Colors.white
//                                     : Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 // Next
//                 MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                   child: GestureDetector(
//                     onTap: currentPage < totalPages
//                         ? () => setState(() => currentPage++)
//                         : null,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: currentPage < totalPages
//                             ? AppColor.primary
//                             : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Text("Next",
//                           style: TextStyle(
//                               color: currentPage < totalPages
//                                   ? Colors.white
//                                   : Colors.black)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';
import '../../model/supervisor/getallsupervisormodel.dart';
import '../../services/attendance_apiservice.dart';
import 'editsupervisorscreen.dart';

class SupervisormasterScreen extends StatefulWidget {
  const SupervisormasterScreen({
    super.key,
    required List<Supervisorlist> supervisors,
    required void Function() onAdd,
    required void Function() onEdit,
  });

  @override
  State<SupervisormasterScreen> createState() => _SupervisormasterScreenState();
}

class _SupervisormasterScreenState extends State<SupervisormasterScreen> {
  final AttendanceApiService apiService = AttendanceApiService();
  bool isLoading = false;
  String currentView = "list"; // "list" | "add" | "edit"
  Supervisorlist? selectedSupervisor;

  List<Supervisorlist> supervisorListPage = [];
  int currentPage = 1;
  final int supervisorPerPage = 7;

  @override
  void initState() {
    super.initState();
    getAllSupervisor();
  }

  // ✅ API call
  Future<void> getAllSupervisor() async {
    setState(() => isLoading = true);

    try {
      var result = await apiService.getAllSupervisor();

      // Debug: check API result
      print("API getAllSupervisor result: $result");

      var response = GetallsupervisorsModel.fromJson(result);

      if (response.status == true) {
      
        setState(() {
          supervisorListPage = (response.data ?? [])
              .map(
                (e) => Supervisorlist(
                  id: e.id ?? '',
                  supervisorid: e.supervisorid ?? 'Unknown',
                  supervisorname: e.supervisorname ?? 'Unknown',
                  type: e.type ?? 'Unknown',
                  status: e.status ?? 'Unknown',
                ),
              )
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          supervisorListPage = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        supervisorListPage = [];
        isLoading = false;
      });
      print("❌ Error fetching supervisors: $e");
    }
  }

  // Pagination helper
  List<int> getVisiblePages(int totalPages) {
    List<int> pages = [];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) pages.add(i);
    } else {
      if (currentPage <= 3) {
        pages.addAll([1, 2, 3, -1, totalPages]);
      } else if (currentPage >= totalPages - 2) {
        pages.addAll([1, -1, totalPages - 2, totalPages - 1, totalPages]);
      } else {
        pages.addAll([
          1,
          -1,
          currentPage - 1,
          currentPage,
          currentPage + 1,
          -1,
          totalPages,
        ]);
      }
    }
    return pages;
  }

 

  @override
  Widget build(BuildContext context) {
    // ===== If Add Page =====
    if (currentView == "add") {
      return Editsupervisorscreen(
        isEdit: false,
        onBack: () => setState(() => currentView = "list"),
        onAdd: (_) async {
          await getAllSupervisor(); // fetch latest
          setState(() => currentView = "list");
        },
        onSave: (_) {},
      );
    }

    // ===== If Edit Page =====
    if (currentView == "edit" && selectedSupervisor != null) {
      return Editsupervisorscreen(
        isEdit: true,
        supervisor: selectedSupervisor,
        onBack: () {
          setState(() {
            currentView = "list";
            selectedSupervisor = null;
          });
        },
        onSave: (_) async {
          await getAllSupervisor(); // fetch latest
          setState(() {
            currentView = "list";
            selectedSupervisor = null;
          });
        },
        onAdd: (_) {},
      );
    }

    int totalPages = (supervisorListPage.length / supervisorPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    int start = (currentPage - 1) * supervisorPerPage;
    int end = (start + supervisorPerPage > supervisorListPage.length)
        ? supervisorListPage.length
        : start + supervisorPerPage;
    List<Supervisorlist> currentSupervisor = supervisorListPage.sublist(
      start,
      end,
    );

    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            // 🔍 Search + Filter + Add
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Center(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO filter
                    },
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    label: const Text(
                      "Filter",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => currentView = "add");
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Add Supervisor Master",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📊 Table
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : currentSupervisor.isEmpty
                  ? const Center(child: Text("No Supervisors Found"))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                AppColor.primaryLight,
                              ),
                              columnSpacing: 120,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Supervisor ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Supervisor Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Type',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Action',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows: currentSupervisor.map((supervisor) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        'S${supervisor.supervisorid.toString().padLeft(4, '0')}',
                                      ),
                                    ),
                                    DataCell(
                                      Text(supervisor.supervisorname ?? ""),
                                    ),
                                    DataCell(Text(supervisor.type ?? "")),
                                    DataCell(
                                      Text(
                                        supervisor.status ?? "",
                                        style: TextStyle(
                                          color: (supervisor.status == "Active")
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedSupervisor = supervisor;
                                            currentView = "edit";
                                          });
                                        },
                                        child: Image.asset(
                                          AppAssets.edit_icon,
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),

            // ⏮ Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Prev
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: currentPage > 1
                            ? AppColor.primary
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Previous",
                        style: TextStyle(
                          color: currentPage > 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                // Pages
                Row(
                  children: getVisiblePages(totalPages).map((page) {
                    if (page == -1) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text("..."),
                      );
                    }
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => setState(() => currentPage = page),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: page == currentPage
                                ? AppColor.primary
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "$page",
                            style: TextStyle(
                              color: page == currentPage
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Next
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: currentPage < totalPages
                            ? AppColor.primary
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: currentPage < totalPages
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

