import 'package:attendance_web/screens/projectallocation/addprojectallication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';

class ProjectallocationScreen extends StatefulWidget {
  const ProjectallocationScreen({super.key, required void Function() onAdd, required bool isEdit, required void Function() onEdit});

  @override
  State<ProjectallocationScreen> createState() => _ProjectallocationScreenState();
}

class _ProjectallocationScreenState extends State<ProjectallocationScreen> {
  
  Allocation? selectedSite;
    String currentView = "list"; // "list" | "add" | "edit"
  Allocation? selectedAllocation;
final List<Allocation> allocations = List.generate(
  500,
  (index) {
    DateTime from = DateTime(2025, 9, (index % 28) + 1);
    DateTime to = DateTime(2025, 12, (index % 28) + 1);

    String formattedFrom = DateFormat('dd-MM-yyyy').format(from);
    String formattedTo = DateFormat('dd-MM-yyyy').format(to);

    return Allocation(
      projectName: "Project ${index + 1}",
      site: "Site ${index + 1}",
      fromdate: formattedFrom,
      todate: formattedTo,
      supervisor: "Supervisor ${index + 1}",
      status: index % 2 == 0 ? "Active" : "Inactive",
    );
  },
);


  int currentPage = 1;
  final int rowsPerPage = 7;

  // dynamic pagination
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
      return Addprojectallicationscreen(
        isEdit: false,
        onBack: () => setState(() => currentView = "list"),
        onAdd: (newAllocation) {
          setState(() {
           
            allocations.add(newAllocation);
            currentView = "list";
          });
        }, onSave: (updatedAllocation) {  },
      );
    }

    // ===== If Edit Page =====
    if (currentView == "edit" && selectedAllocation != null) {
      return Addprojectallicationscreen(
        isEdit: true,
        allocation: selectedSite,
        onBack: () => setState(() {
          currentView = "list";
          selectedSite = null;
        }),
        onSave: (updatedSite) {
          setState(() {
            // // int index = allocations.indexWhere((s) => s.id == updatedSite.id);
            // if (index != -1) allocations[index] = updatedSite;
            currentView = "list";
          });
        }, onAdd: (newSite) {  },
      );
    }
  
    int totalPages = (allocations.length / rowsPerPage).ceil();

    int start = (currentPage - 1) * rowsPerPage;
    int end = (start + rowsPerPage > allocations.length)
        ? allocations.length
        : start + rowsPerPage;
    List<Allocation> currentAllocations = allocations.sublist(start, end);

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
                    child: Center(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              AppAssets.search,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
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
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                           setState(() => currentView = "add");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.filter_list, color: Colors.black, size: 24),
                        SizedBox(width: 4),
                        Text('Filter', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 200),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                        setState(() => currentView = "add");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add, color: Colors.white, size: 24),
                        SizedBox(width: 4),
                        Text(
                          'Add Allocation',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📋 Table
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(AppColor.primaryLight),
                        columnSpacing: 60,
                        columns: const [
                          DataColumn(label: Text('Project Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Site', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('From Date', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('To Date', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Supervisor', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          // DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: currentAllocations.map((alloc) {
                          return DataRow(
                            cells: [
                              DataCell(Text(alloc.projectName)),
                              DataCell(Text(alloc.site)),
                              DataCell(Text(alloc.fromdate)),
                              DataCell(Text(alloc.todate)),
                              DataCell(Text(alloc.supervisor)),
                              DataCell(
                                Text(
                                  alloc.status,
                                  style: TextStyle(
                                    color: alloc.status == "Active"
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // DataCell(
                              //   InkWell(
                              //     onTap: () {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(content: Text('Edit ${alloc.projectName}')),
                              //       );
                              //     },
                              //     child: Image.asset(
                              //       AppAssets.edit_icon,
                              //       width: 16,
                              //       height: 16,
                              //     ),
                              //   ),
                              // ),
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

            // ⏮️ Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous
                MouseRegion(
                   cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: currentPage > 1 ? () => setState(() => currentPage--) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: currentPage > 1 ? AppColor.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: currentPage > 1 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Numbers
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
                        onTap: () => setState(() => currentPage = page),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: page == currentPage ? AppColor.primary : Colors.grey[300],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              '$page',
                              style: TextStyle(
                                color: page == currentPage ? Colors.white : Colors.black,
                                fontSize: 14,
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
                   cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: currentPage < totalPages ? AppColor.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: currentPage < totalPages ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
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

class Allocation {
   String projectName;
   String site;
   String fromdate;
   String todate;
   String supervisor;
   String status;

  Allocation({
    required this.projectName,
    required this.site,
    required this.fromdate,
    required this.todate,
    required this.supervisor,
    required this.status,
  });

  get name => null;

  get address => null;
}
