import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
import '../../bloc/event/supervisor/deletesupervisor_event.dart';
import '../../bloc/event/supervisor/supervisor_event.dart';
import '../../bloc/state/supervisor/deletesupervisor_state.dart';
import '../../bloc/bloc/supervisor/deletesupervisor_bloc.dart';
import '../../constant/utils.dart';
import '../../model/supervisor/getallsupervisormodel.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';

class SupervisormasterScreen extends StatefulWidget {
  final List<Supervisorlist> supervisors;
  final void Function() onAdd;
  final void Function(Supervisorlist) onEdit;

  const SupervisormasterScreen({
    super.key,
    required this.supervisors,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  State<SupervisormasterScreen> createState() => _SupervisormasterScreenState();
}

class _SupervisormasterScreenState extends State<SupervisormasterScreen> {
  String searchText = "";
  int currentPage = 1;
  final int supervisorsPerPage = 8;
  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserRole(); // 🔥 call your SharedPrefs here
  }

  Future<void> _loadUserRole() async {
    final userRole = await SharedPrefs.getUserRole(); // 👈 call your method
    setState(() {
      role = userRole?.toLowerCase(); // always lowercase for consistency
    });
  }

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
  void _onDeleteSupervisor(
    BuildContext context,
    Supervisorlist supervisor,
  ) async {
    print(
      "🟠 Delete button tapped for supervisor: ${supervisor.supervisorname} (ID: ${supervisor.id})",
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text(
          "Are you sure you want to delete '${supervisor.supervisorname}'?",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.actionColor,
            ),
            onPressed: () {
              print(
                "✅ Delete confirmed for supervisor: ${supervisor.supervisorname}",
              );
              Navigator.pop(ctx, true);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              print("❌ Delete cancelled by user");
              Navigator.pop(ctx, false);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
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
    print(
      "🚀 Dispatching DeleteSupervisorBloc event with ID: ${supervisor.id}",
    );
    context.read<DeleteSupervisorBloc>().add(
      SubmitDeleteSupervisor(id: supervisor.id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter supervisors by search text
    List<Supervisorlist> filteredSupervisors = widget.supervisors
        .where(
          (s) =>
              (s.supervisorname ?? "").toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              (s.supervisorid ?? "").toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              (s.type ?? "").toLowerCase().contains(searchText.toLowerCase()) ||
              (s.status ?? "").toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();

    int totalPages = (filteredSupervisors.length / supervisorsPerPage)
        .ceil()
        .clamp(1, 999);
    int start = (currentPage - 1) * supervisorsPerPage;
    int end = (start + supervisorsPerPage > filteredSupervisors.length)
        ? filteredSupervisors.length
        : start + supervisorsPerPage;
    List<Supervisorlist> currentSupervisors = filteredSupervisors.sublist(
      start,
      end,
    );

    return BlocListener<DeleteSupervisorBloc, DeleteSupervisorState>(
      listener: (context, state) {
        print("🟢 DeleteSupervisorBloc state changed: $state");

        if (state is DeleteSupervisorLoading) {
          print("⏳ Deleting supervisor...");
        } else if (state is DeleteSupervisorSuccess) {
          print("✅ Supervisor deleted successfully: ${state.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? "Supervisor deleted successfully"),
            ),
          );
          print("🔄 Refreshing supervisor list...");
          context.read<SupervisorBloc>().add(FetchSupervisorsEvent());
        } else if (state is DeleteSupervisorFailure) {
          print("❌ Failed to delete supervisor: ${state.error}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? "Delete failed")),
          );
        } else {
          print("⚪ Unknown state: $state");
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primaryLight,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search + Add
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
                          hintText: "Search supervisors...",
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ✅ Show only for admin
                  if (role == "admin") ...[
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
                          "Add Supervisor",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // Table inside a neat Container
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
                      if (currentSupervisors.isEmpty) {
                        return const Center(
                          child: Text("No Supervisors Found"),
                        );
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
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: 60,
                                    child: Text(
                                      'ID',
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.bold,
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
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 100,
                                    child: Text(
                                      'Type',
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 100,
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                if (role == "admin") ...[
                                  DataColumn(
                                    label: SizedBox(
                                         width: 100,
                                      child: Text(
                                        'Action',
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],

                              rows: List.generate(currentSupervisors.length, (
                                index,
                              ) {
                                final supervisor = currentSupervisors[index];
                                final isEven = index % 2 == 0;
                                return DataRow(
                                  color: MaterialStateProperty.all(
                                    isEven ? Colors.grey.shade50 : Colors.white,
                                  ),
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          supervisor.supervisorid ?? '-',
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          supervisor.supervisorname ?? '-',
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 120,
                                        child: Text(supervisor.type ?? '-'),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        supervisor.status ?? '-',
                                        style: TextStyle(
                                          color: supervisor.status == 'Active'
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (role == "admin") ...[
                                      DataCell(
                                        Row(
                                          children: [
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () =>
                                                  widget.onEdit(supervisor),
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
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () => _onDeleteSupervisor(
                                                context,
                                                supervisor,
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
                                  ],
                                );
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

              // Pagination
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
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

                  // Next Button
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

