import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';
import 'editprojectmasterscreen.dart';

class ProjectmasterScreen extends StatefulWidget {
  const ProjectmasterScreen({super.key, required void Function() onAdd, required void Function() onEdit});

  @override
  State<ProjectmasterScreen> createState() => _ProjectmasterScreenState();
}

class _ProjectmasterScreenState extends State<ProjectmasterScreen> {
    String currentView = "list"; // "list" | "add" | "edit"
  Project? selectedProject;
  final List<Project> project = List.generate(
    53,
    (index) => Project(
      id: index + 1,
      name: 'Project ${index + 1}',
      address: 'Address ${index + 1}',
     
      status: (index % 2 == 0) ? 'Active' : 'Inactive',
    ),
  );

  int currentPage = 1;
  final int projectPerPage = 7;

  // Generate dynamic page numbers
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
      return Editprojectmasterscreen(
        isEdit: false,
        onBack: () => setState(() => currentView = "list"),
        onAdd: (newProject) {
          setState(() {
            newProject.id = project.length + 1;
            project.add(newProject);
            currentView = "list";
          });
        }, onSave: (updatedSite) {  },
      );
    }

    // ===== If Edit Page =====
    if (currentView == "edit" && selectedProject != null) {
      return Editprojectmasterscreen(
        isEdit: true,
        project: selectedProject,
        onBack: () => setState(() {
          currentView = "list";
          selectedProject = null;
        }),
        onSave: (updatedSite) {
          setState(() {
            int index = project.indexWhere((s) => s.id == updatedSite.id);
            if (index != -1) project[index] = updatedSite;
            currentView = "list";
          });
        }, onAdd: (newSite) {  },
      );
    }
    int totalPages = (project.length / projectPerPage).ceil();

    int start = (currentPage - 1) * projectPerPage;
    int end = (start + projectPerPage > project.length)
        ? project.length
        : start + projectPerPage;
    List<Project> currentProject= project.sublist(start, end);

    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            // Search + Filter + Add
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
                const SizedBox(width: 12), // Gap between search box and filter
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
                    onPressed: () {},
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
                          'Add Project Master',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),


Expanded(
  child: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: DataTable(
              headingRowColor:
                  MaterialStateProperty.all(AppColor.primaryLight),
              columnSpacing: 120,
              columns: const [
                DataColumn(
                  label: Text(
                    'Project ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Project Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Project Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
               
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: currentProject.map((project) {
                return DataRow(
                  cells: [
                    DataCell(Text('P${project.id.toString().padLeft(4, '0')}')),
                    DataCell(Text(project.name)),
                    DataCell(Text(project.address)),
           
                    DataCell(
                      Text(
                        project.status,
                        style: TextStyle(
                          color: project.status == 'Active'
                              ? Colors.green[800]
                              : Colors.red[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(
                      InkWell(
                        onTap: () {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text('Action ${project.name}')),
                          // );
                            
                                      setState(() {
                                        selectedProject = project;
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
        ),
      );
    },
  ),
)
,
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
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
                        borderRadius: BorderRadius.circular(50), // fully rounded
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

                // Page Number Buttons
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ), // space between numbers
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: page == currentPage
                                  ? AppColor.primary
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(50), // rounded
                            ),
                            child: Text(
                              '$page',
                              style: TextStyle(
                                color: page == currentPage
                                    ? Colors.white
                                    : Colors.black,
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

                // Next Button
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
                        borderRadius: BorderRadius.circular(50), // fully rounded
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
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class Project {
   int id;
   String name;
   String address;
 
   String status;

  Project({
    required this.id,
    required this.name,
    required this.address,
   
    required this.status,
  });
}
