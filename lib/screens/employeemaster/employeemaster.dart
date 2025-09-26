import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';
import 'editemployeescreen.dart';

class EmployeemasterScreen extends StatefulWidget {
  const EmployeemasterScreen({super.key, required void Function() onAdd, required void Function() onEdit});

  @override
  State<EmployeemasterScreen> createState() => _EmployeemasterScreenState();
}

class _EmployeemasterScreenState extends State<EmployeemasterScreen> {
    String currentView = "list"; // "list" | "add" | "edit"
  Employee? selectedEmployee;
  final List<Employee> employee = List.generate(
    53,
    (index) => Employee(
      id: index + 1,
      name: 'Employee ${index + 1}',
    type: (index % 3 == 0)
    ? 'Permanent'
    : (index % 3 == 1)
        ? 'Temporary'
        : 'Contract',

     
      status: (index % 2 == 0) ? 'Active' : 'Inactive',
    ),
  );

  int currentPage = 1;
  final int employeePerPage = 7;

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
      return Editemployeescreen(
        isEdit: false,
        onBack: () => setState(() => currentView = "list"),
        onAdd: (newEmployee) {
          setState(() {
            newEmployee.id = employee.length + 1;
            employee.add(newEmployee);
            currentView = "list";
          });
        }, onSave: (updatedEmployee) {  },
      );
    }

    // ===== If Edit Page =====
    if (currentView == "edit" && selectedEmployee!= null) {
      return Editemployeescreen(
        isEdit: true,
        employee: selectedEmployee,
        onBack: () => setState(() {
          currentView = "list";
          selectedEmployee = null;
        }),
        onSave: (updatedEmployee) {
          setState(() {
            int index = employee.indexWhere((s) => s.id == updatedEmployee.id);
            if (index != -1) employee[index] = updatedEmployee;
            currentView = "list";
          });
        }, onAdd: (newEmployee) {  },
      );
    }
    int totalPages = (employee.length / employeePerPage).ceil();

    int start = (currentPage - 1) * employeePerPage;
    int end = (start + employeePerPage >employee.length)
        ? employee.length
        : start + employeePerPage;
    List<Employee> currentProject= employee.sublist(start, end);

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
                    onPressed: () {
                     
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
                          'Add Employee Master',
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
                    'Employee ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Employee Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Type',
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
              rows: currentProject.map((employee) {
                return DataRow(
                  cells: [
                    DataCell(Text('E${employee.id.toString().padLeft(4, '0')}')),
                    DataCell(Text(employee.name)),
                    DataCell(Text(employee.type)),
           
                    DataCell(
                      Text(
                        employee.status,
                        style: TextStyle(
                          color: employee.status == 'Active'
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
                          //   SnackBar(content: Text('Action ${employee.name}')),
                          // );
                             setState(() {
                                        selectedEmployee = employee;
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

class Employee {
   int id;
   String name;
   String type;
 
   String status;

  Employee({
    required this.id,
    required this.name,
    required this.type,
   
    required this.status,
  });
}
