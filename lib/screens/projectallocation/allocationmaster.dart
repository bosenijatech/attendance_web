



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart'; // ✅ for date formatting

import '../../bloc/bloc/allocation/allocation_bloc.dart';
import '../../bloc/bloc/allocation/deleteallocation_bloc.dart';
import '../../bloc/event/allocation/allocation_event.dart';
import '../../bloc/event/allocation/deleteallocation_event.dart';
import '../../bloc/state/allocation/deleteallocationstate.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';
import '../../model/allocation/getallallocationmodel.dart';

class AllocationmasterScreen extends StatefulWidget {
  final List<Allocationlist> allocation;
  final void Function() onAdd;
  final void Function(Allocationlist) onEdit;

  const AllocationmasterScreen({
    super.key,
    required this.allocation,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  State<AllocationmasterScreen> createState() =>
      _AllocationmasterScreenState();
}

class _AllocationmasterScreenState extends State<AllocationmasterScreen> {
  String searchText = "";
  int currentPage = 1;
  final int allocationPerPage = 7;

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("dd-MM-yyyy").format(date); // ✅ format nicely
    } catch (e) {
      return dateStr; // fallback if parsing fails
    }
  }

  List<int> getVisiblePages(int totalPages) {
    List<int> pages = [];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) pages.add(i);
    } else {
      if (currentPage <= 3) {
        pages.addAll([1, 2, 3, 4, -1, totalPages]);
      } else if (currentPage >= totalPages - 2) {
        pages.addAll([1, -1, totalPages - 3, totalPages - 2, totalPages - 1, totalPages]);
      } else {
        pages.addAll([1, -1, currentPage - 1, currentPage, currentPage + 1, -1, totalPages]);
      }
    }
    return pages;
  }



  // 🔥 Delete Function
void _onDeleteallocation(BuildContext context, Allocationlist allocation) async {
  print("🟠 Delete button tapped for allocation: ${allocation.allocationid} (ID: ${allocation.id})");

  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Confirm Delete"),
      content: Text("Are you sure you want to delete '${allocation.allocationid}'?"),
      actions: [
         ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.actionColor),
          onPressed: () {
            print("✅ Delete confirmed for allocation: ${allocation.allocationid}");
            Navigator.pop(ctx, true);
          },
          child: const Text("Delete", style: TextStyle(color: Colors.white),),
        ),
        TextButton(
          onPressed: () {
            print("❌ Delete cancelled by user");
            Navigator.pop(ctx, false);
          },
          child: const Text("Cancel",style: TextStyle(color: Colors.black),),
        ),
       
      ],
    ),
  );

  print("🟡 Dialog result: $confirm");

  if (confirm != true) {
    print("🚫 Delete action aborted");
    return;
  }

  // 🔥 Trigger Delete Bloc Event
  print("🚀 Dispatching DeleteallocationBloc event with ID: ${allocation.id}");
  context.read<DeleteAllocationBloc>().add(
        SubmitDeleteAllocation(id: allocation.id.toString()),
      );
}



  @override
  Widget build(BuildContext context) {
    List<Allocationlist> filteredAllocation = widget.allocation
        .where((s) =>
            (s.projectname ?? "")
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            (s.sitename ?? "")
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            (s.status ?? "")
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();

    int totalPages =
        (filteredAllocation.length / allocationPerPage).ceil().clamp(1, 999);
    int start = (currentPage - 1) * allocationPerPage;
    int end = (start + allocationPerPage > filteredAllocation.length)
        ? filteredAllocation.length
        : start + allocationPerPage;
    List<Allocationlist> currentAllocation =
        filteredAllocation.sublist(start, end);

    return 
    

    
 BlocListener<DeleteAllocationBloc, DeleteAllocationState>(
  listener: (context, state) {


    if (state is DeleteAllocationLoading) {
    
    } else if (state is DeleteAllocationSuccess) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message ?? "Allocation deleted successfully")),
      );
   
      context.read<AllocationBloc>().add(FetchAllocationEvent());
    } else if (state is DeleteAllocationFailure) {
  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error ?? "Delete failed")),
      );
    } else {
   
    }
  },
    
      child: Scaffold(
        backgroundColor: AppColor.primaryLight,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔍 Search + ➕ Add
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
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            searchText = val;
                            currentPage = 1;
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search Allocation...",
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton.icon(
                      onPressed: widget.onAdd,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Allocation",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 16),
      
              // 📋 Table
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
                      if (currentAllocation.isEmpty) {
                        return const Center(child: Text("No Allocation Found"));
                      }
      
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: Container(
                                    decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior:
                                Clip.antiAlias, // important for rounded corners
                            child: DataTable(
                             
                              headingRowHeight: 40,
                              dataRowHeight: 43,
                              columnSpacing: 30,
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
                                    width: 80,
                                    child: Text('Allocation ID',
                                        style: TextStyle(
                                          color: AppColor.primary,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                DataColumn(label: SizedBox(
                                  width: 80,
                                  child: Text('Project', style: TextStyle(
                                    color: AppColor.primary,fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(label: SizedBox(width: 80,
                                  child: Text('Site', style: TextStyle(
                                    color: AppColor.primary,fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(label: SizedBox(width: 80,
                                  child: Text('From Date', style: TextStyle(
                                    color: AppColor.primary,fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(label: SizedBox(width: 80,
                                  child: Text('To Date', style: TextStyle(
                                    color: AppColor.primary,fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(label: SizedBox(width: 80,
                                  child: Text('Supervisor', style: TextStyle(
                                     color: AppColor.primary,
                                    fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(label: SizedBox(width: 80,
                                  child: Text(
                                    'Status', style: TextStyle(
                                      
                                          color: AppColor.primary,fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(label: Text('Action', style: TextStyle(
                                      color: AppColor.primary,fontWeight: FontWeight.bold))),
                              ],
                             
                                 rows: List.generate(currentAllocation.length, (
                                index,
                              ) 
                               {

                                  final allocation = currentAllocation[index];
                                final isEven = index % 2 == 0;
                                return DataRow(
                                     color: MaterialStateProperty.all(
                                    isEven ? Colors.grey.shade50 : Colors.white,
                                  ),
                                  cells: [
                                   DataCell(SizedBox(
                                      width: 80, child: Text(allocation.allocationid ?? '-'))),
                                  DataCell(SizedBox(width: 80,child: Text(allocation.projectname ?? '-'))),
                                  DataCell(SizedBox(width: 80,child: Text(allocation.sitename ?? '-'))),
                                  DataCell(SizedBox(width: 80,child: Text(formatDate(allocation.fromDate)))), // ✅ formatted
                                  DataCell(SizedBox(width: 80,child: Text(formatDate(allocation.toDate)))),   // ✅ formatted
                                  DataCell(SizedBox(width: 80,child: Text(allocation.supervisorname ?? '-'))),
                                  DataCell(Text(
                                    allocation.status ?? '-',
                                    style: TextStyle(
                                      color: allocation.status == 'Active'
                                          ? Colors.green[800]
                                          : Colors.red[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                 DataCell(
                                        Row(
                                          children: [
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () =>
                                                  widget.onEdit(allocation),
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
                                              onTap: () =>
                                                  _onDeleteallocation(context, allocation),
                                              child: Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: AppColor.actionColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ]);
                              }).toList(),
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
                  // ⬅️ Prev
                  MouseRegion(
                     cursor: currentPage > 1
                         ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
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
      
                  // Page numbers
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
                                color: page == currentPage
                                    ? AppColor.primary
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                '$page',
                                style: TextStyle(
                                  color: page == currentPage ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
      
                  // ➡️ Next
                  MouseRegion(
                     cursor: currentPage < totalPages
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: GestureDetector(
                      onTap: currentPage < totalPages
                          ? () => setState(() => currentPage++)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: currentPage < totalPages
                              ? AppColor.primary
                              : Colors.grey[300],
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
            ],
          ),
        ),
      ),
    );
  }
}
