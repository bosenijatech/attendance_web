// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../bloc/bloc/projectmaster/deleteproject_bloc.dart';
// import '../../bloc/bloc/projectmaster/project_bloc.dart';
// import '../../bloc/event/projectmaster/deleteproject_event.dart';
// import '../../bloc/event/projectmaster/project_event.dart';
// import '../../bloc/state/projectmaster/deleteproject_state.dart';
// import '../../model/projectmaster/getallprojectmodel.dart';

// import '../../constant/app_color.dart';
// import '../../constant/app_assets.dart';

// class ProjectmasterScreen extends StatefulWidget {
//   final List<Projectlist> project;
//   final void Function() onAdd;
//   final void Function(Projectlist) onEdit;

//   const ProjectmasterScreen({
//     super.key,
//     required this.project,
//     required this.onAdd,
//     required this.onEdit,
//   });

//   @override
//   State<ProjectmasterScreen> createState() => _ProjectmasterScreenState();
// }

// class _ProjectmasterScreenState extends State<ProjectmasterScreen> {
//   String searchText = "";
//   int currentPage = 1;
//   final int projectPerPage = 7;

//   List<int> getVisiblePages(int totalPages) {
//     List<int> pages = [];
//     if (totalPages <= 5) {
//       for (int i = 1; i <= totalPages; i++) pages.add(i);
//     } else {
//       if (currentPage <= 3) {
//         pages.addAll([1, 2, 3, 4, -1, totalPages]);
//       } else if (currentPage >= totalPages - 2) {
//         pages.addAll([
//           1,
//           -1,
//           totalPages - 3,
//           totalPages - 2,
//           totalPages - 1,
//           totalPages
//         ]);
//       } else {
//         pages.addAll([
//           1,
//           -1,
//           currentPage - 1,
//           currentPage,
//           currentPage + 1,
//           -1,
//           totalPages
//         ]);
//       }
//     }
//     return pages;
//   }

//   // 🔥 Delete Function
// void _onDeleteProject(BuildContext context, Projectlist project) async {
//   print("🟠 Delete button tapped for Project: ${project.projectname} (ID: ${project.id})");

//   final confirm = await showDialog<bool>(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       title: const Text("Confirm Delete"),
//       content: Text("Are you sure you want to delete '${project.projectname}'?"),
//       actions: [
//          ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: AppColor.actionColor),
//           onPressed: () {
//             print("✅ Delete confirmed for project: ${project.projectname}");
//             Navigator.pop(ctx, true);
//           },
//           child: const Text("Delete", style: TextStyle(color: Colors.white),),
//         ),
//         TextButton(
//           onPressed: () {
//             print("❌ Delete cancelled by user");
//             Navigator.pop(ctx, false);
//           },
//           child: const Text("Cancel",style: TextStyle(color: Colors.black),),
//         ),

//       ],
//     ),
//   );

//   print("🟡 Dialog result: $confirm");

//   if (confirm != true) {
//     print("🚫 Delete action aborted");
//     return;
//   }

//   // 🔥 Trigger Delete Bloc Event
//   print("🚀 Dispatching DeleteProjectBloc event with ID: ${project.id}");
//   context.read<DeleteProjectBloc>().add(
//         SubmitDeleteProject(id: project.id.toString()),
//       );
// }

//   @override
//   Widget build(BuildContext context) {
//     // Filter Project by search text
//     List<Projectlist> filteredProject = widget.project
//         .where((s) =>
//             (s.projectname ?? "")
//                 .toLowerCase()
//                 .contains(searchText.toLowerCase()) ||
//             (s.projectid ?? "")
//                 .toLowerCase()
//                 .contains(searchText.toLowerCase()) ||
//             (s.projectaddress ?? "")
//                 .toLowerCase()
//                 .contains(searchText.toLowerCase()) ||
//             (s.status ?? "")
//                 .toLowerCase()
//                 .contains(searchText.toLowerCase()))
//         .toList();

//     int totalPages = (filteredProject.length / projectPerPage).ceil().clamp(1, 999);
//     int start = (currentPage - 1) * projectPerPage;
//     int end = (start + projectPerPage > filteredProject.length)
//         ? filteredProject.length
//         : start + projectPerPage;
//     List<Projectlist> currentProject = filteredProject.sublist(start, end);

//     return

//  BlocListener<DeleteProjectBloc, DeleteProjectState>(
//   listener: (context, state) {
//     print("🟢 DeleteProjectBloc state changed: $state");

//     if (state is DeleteProjectLoading) {
//       print("⏳ Deleting Project...");
//     } else if (state is DeleteProjectSuccess) {
//       print("✅ Project deleted successfully: ${state.message}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(state.message ?? "Project deleted successfully")),
//       );
//       print("🔄 Refreshing Project list...");
//       context.read<ProjectBloc>().add(FetchProjectEvent());
//     } else if (state is DeleteProjectFailure) {
//       print("❌ Failed to delete Project: ${state.error}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(state.error ?? "Delete failed")),
//       );
//     } else {
//       print("⚪ Unknown state: $state");
//     }
//   },

//       child: Scaffold(
//         backgroundColor: AppColor.primaryLight,
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // 🔍 Search + Add button
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade300, width: 1),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: TextField(
//                         onChanged: (val) {
//                           setState(() {
//                             searchText = val;
//                             currentPage = 1;
//                           });
//                         },
//                         textAlignVertical: TextAlignVertical.center,
//                         decoration: InputDecoration(
//                           hintText: "Search Project...",
//                           prefixIcon: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: SvgPicture.asset(
//                               AppAssets.search,
//                               width: 20,
//                               height: 20,
//                             ),
//                           ),
//                           border: InputBorder.none,
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     height: 40,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: AppColor.primary,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextButton.icon(
//                       onPressed: widget.onAdd,
//                       icon: const Icon(Icons.add, color: Colors.white),
//                       label: const Text(
//                         "Add Project",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // 📋 Table container
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       if (currentProject.isEmpty) {
//                         return const Center(child: Text("No Project Found"));
//                       }

//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: ConstrainedBox(
//                           constraints:
//                               BoxConstraints(minWidth: constraints.maxWidth),
//                           child: DataTable(
//                             headingRowHeight: 30,
//                             columnSpacing: 80, // 🔧 Reduced spacing between columns
//                             columns: [
//                               DataColumn(
//                                 label: SizedBox(
//                                   width: 60,
//                                   child: Text('ID',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                               DataColumn(
//                                 label: SizedBox(
//                                   width: 100,
//                                   child: Text('Name',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                               DataColumn(
//                                 label: SizedBox(
//                                   width: 120, // 👈 Reduced width for Address
//                                   child: Text('Address',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),

//                               DataColumn(
//                                 label: SizedBox(
//                                   width: 70,
//                                   child: Text('Status',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                               DataColumn(
//                                 label: SizedBox(
//                                   width: 60,
//                                   child: Text('Action',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                               ),
//                             ],
//                             rows: currentProject.map((project) {
//                               return DataRow(cells: [
//                                 DataCell(SizedBox(
//                                     width: 60, child: Text(project.projectid ?? '-'))),
//                                 DataCell(SizedBox(
//                                     width: 100, child: Text(project.projectname ?? '-'))),
//                                 DataCell(SizedBox(
//                                     width: 120,
//                                     child: Text(project.projectaddress ?? '-'))),
//                                   DataCell(
//                                     Text(
//                                       project.status ?? '-',
//                                       style: TextStyle(
//                                         color: project.status == 'Active'
//                                             ? Colors.green[800]
//                                             : Colors.red[800],
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                DataCell(
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           hoverColor: Colors.transparent,
//                                           splashColor: Colors.transparent,
//                                           highlightColor: Colors.transparent,
//                                           onTap: () =>
//                                               widget.onEdit(project),
//                                           child: Icon(
//                                             Icons.edit,
//                                             size: 20,
//                                             color: AppColor.primary,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 24),
//                                         InkWell(
//                                           hoverColor: Colors.transparent,
//                                           splashColor: Colors.transparent,
//                                           highlightColor: Colors.transparent,
//                                           onTap: () =>
//                                               _onDeleteProject(context, project),
//                                           child: Icon(
//                                             Icons.delete,
//                                             size: 20,
//                                             color: AppColor.actionColor,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                               ]);
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // 🔢 Pagination
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Previous
//                   MouseRegion(
//                     cursor: currentPage > 1
//                         ? SystemMouseCursors.click
//                         : SystemMouseCursors.basic,
//                     child: GestureDetector(
//                       onTap:
//                           currentPage > 1 ? () => setState(() => currentPage--) : null,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: currentPage > 1
//                               ? AppColor.primary
//                               : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Text(
//                           'Previous',
//                           style: TextStyle(
//                             color: currentPage > 1 ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Page numbers
//                   Row(
//                     children: getVisiblePages(totalPages).map((page) {
//                       if (page == -1) {
//                         return const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 6),
//                           child: Text('...', style: TextStyle(fontSize: 14)),
//                         );
//                       }
//                       return MouseRegion(
//                         cursor: SystemMouseCursors.click,
//                         child: GestureDetector(
//                           onTap: () {
//                             if (page != currentPage) {
//                               setState(() => currentPage = page);
//                             }
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: page == currentPage
//                                     ? AppColor.primary
//                                     : Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Text(
//                                 '$page',
//                                 style: TextStyle(
//                                   color: page == currentPage
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),

//                   // Next
//                   MouseRegion(
//                     cursor: currentPage < totalPages
//                         ? SystemMouseCursors.click
//                         : SystemMouseCursors.basic,
//                     child: GestureDetector(
//                       onTap: currentPage < totalPages
//                           ? () => setState(() => currentPage++)
//                           : null,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: currentPage < totalPages
//                               ? AppColor.primary
//                               : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Text(
//                           'Next',
//                           style: TextStyle(
//                             color:
//                                 currentPage < totalPages ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/bloc/projectmaster/deleteproject_bloc.dart';
import '../../bloc/bloc/projectmaster/project_bloc.dart';
import '../../bloc/event/projectmaster/deleteproject_event.dart';
import '../../bloc/event/projectmaster/project_event.dart';
import '../../bloc/state/projectmaster/deleteproject_state.dart';
import '../../model/projectmaster/getallprojectmodel.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';

class ProjectmasterScreen extends StatefulWidget {
  final List<Projectlist> project;
  final void Function() onAdd;
  final void Function(Projectlist) onEdit;

  const ProjectmasterScreen({
    super.key,
    required this.project,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  State<ProjectmasterScreen> createState() => _ProjectmasterScreenState();
}

class _ProjectmasterScreenState extends State<ProjectmasterScreen> {
  String searchText = "";
  int currentPage = 1;
  final int projectPerPage = 8;

  List<int> getVisiblePages(int totalPages) {
    List<int> pages = [];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) pages.add(i);
    } else {
      if (currentPage <= 3) {
        pages.addAll([1, 2, 3, 4, -1, totalPages]);
      } else if (currentPage >= totalPages - 2) {
        pages.addAll([
          1,
          -1,
          totalPages - 3,
          totalPages - 2,
          totalPages - 1,
          totalPages,
        ]);
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

  // 🔥 Delete Function
  void _onDeleteProject(BuildContext context, Projectlist project) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text(
          "Are you sure you want to delete '${project.projectname}'?",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.actionColor,
            ),
            onPressed: () {
              Navigator.pop(ctx, true);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    context.read<DeleteProjectBloc>().add(
      SubmitDeleteProject(id: project.id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔎 Filter Project by search text
    List<Projectlist> filteredProject = widget.project
        .where(
          (s) =>
              (s.projectname ?? "").toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              (s.projectid ?? "").toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              (s.projectaddress ?? "").toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              (s.status ?? "").toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();

    int totalPages = (filteredProject.length / projectPerPage).ceil().clamp(
      1,
      999,
    );
    int start = (currentPage - 1) * projectPerPage;
    int end = (start + projectPerPage > filteredProject.length)
        ? filteredProject.length
        : start + projectPerPage;
    List<Projectlist> currentProject = filteredProject.sublist(start, end);

    return BlocListener<DeleteProjectBloc, DeleteProjectState>(
      listener: (context, state) {
        if (state is DeleteProjectSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? "Project deleted successfully"),
            ),
          );
          context.read<ProjectBloc>().add(FetchProjectEvent());
        } else if (state is DeleteProjectFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? "Delete failed")),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryLight,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔍 Search + Add
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            searchText = val;
                            currentPage = 1;
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search Project...",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              AppAssets.search,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton.icon(
                      onPressed: widget.onAdd,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Project",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 📋 Table container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (currentProject.isEmpty) {
                        return const Center(child: Text("No Project Found"));
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior:
                                Clip.antiAlias, // important for rounded corners
                            child: DataTable(
                              headingRowHeight: 40,
                              dataRowHeight: 43,
                              columnSpacing: 120,
                              dividerThickness: 0.2, // 👈 divider between rows
                              headingRowColor: MaterialStateProperty.all(
                                AppColor.primaryLight,
                              ), // 👈 header background
                              dataRowColor:
                                  MaterialStateProperty.resolveWith<Color?>((
                                    Set<MaterialState> states,
                                  ) {
                                    if (states.contains(
                                      MaterialState.hovered,
                                    )) {
                                      return Colors.grey.shade100;
                                    }
                                    return Colors.white; // default
                                  }),
                              columns: const [
                                DataColumn(
                                  label: SizedBox(
                                    width: 60,
                                    child: Text(
                                      'ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 100,
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 120,
                                    child: Text(
                                      'Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 70,
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 60,
                                    child: Text(
                                      'Action',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(currentProject.length, (
                                index,
                              ) 
                              {
                                final project = currentProject[index];
                                final isEven = index % 2 == 0;
                                return DataRow(
                                  color: MaterialStateProperty.all(
                                    isEven ? Colors.grey.shade50 : Colors.white,
                                  ),
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: 60,
                                        child: Text(project.projectid ?? '-'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Text(project.projectname ?? '-'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          project.projectaddress ?? '-',
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        project.status ?? '-',
                                        style: TextStyle(
                                          color: project.status == 'Active'
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          InkWell(
                                            hoverColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () => widget.onEdit(project),
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: AppColor.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          InkWell(
                                            hoverColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () => _onDeleteProject(
                                              context,
                                              project,
                                            ),
                                            child: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: AppColor.actionColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔢 Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous
                  MouseRegion(
                    cursor: currentPage > 1
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
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
                          'Previous',
                          style: TextStyle(
                            color: currentPage > 1
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Page Numbers
                  Row(
                    children: getVisiblePages(totalPages).map((page) {
                      if (page == -1) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text('...', style: TextStyle(fontSize: 14)),
                        );
                      }
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            if (page != currentPage) {
                              setState(() => currentPage = page);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
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
                                '$page',
                                style: TextStyle(
                                  color: page == currentPage
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Next
                  MouseRegion(
                    cursor: currentPage < totalPages
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
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
                          'Next',
                          style: TextStyle(
                            color: currentPage < totalPages
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
