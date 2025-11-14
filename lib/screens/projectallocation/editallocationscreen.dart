


import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc/allocation/allocation_bloc.dart';
import '../../bloc/bloc/allocation/editallocation_bloc.dart';
import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
import '../../bloc/bloc/projectmaster/project_bloc.dart';
import '../../bloc/bloc/site/site_bloc.dart';
import '../../bloc/bloc/employee/employee_bloc.dart';
import '../../bloc/event/allocation/allocation_event.dart';
import '../../bloc/event/allocation/editallocation_event.dart';
import '../../bloc/event/supervisor/supervisor_event.dart';
import '../../bloc/event/projectmaster/project_event.dart';
import '../../bloc/event/site/site_event.dart';
import '../../bloc/event/employee/employee_event.dart';
import '../../bloc/state/allocation/editallocation_state.dart';
import '../../bloc/state/supervisor/supervisor_state.dart';
import '../../bloc/state/projectmaster/project_state.dart';
import '../../bloc/state/site/site_state.dart';
import '../../bloc/state/employee/employee_state.dart';
import '../../constant/app_color.dart';
import '../../model/allocation/getallallocationmodel.dart';
import '../../model/projectmaster/getallprojectmodel.dart';
import '../../model/site/getallsitemodel.dart';
import '../../model/employee/getallemployeemodel.dart';
import '../../model/supervisor/getallsupervisormodel.dart';
import '../../services/attendance_apiservice.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/customdatepicker.dart';

class EditAllocationScreen extends StatefulWidget {
  final AttendanceApiService apiService;
  final AllocationBloc allocationBloc;
  final Allocationlist allocation;
  final VoidCallback onBack;
  final VoidCallback onAllocationUpdated;

  const EditAllocationScreen({
    Key? key,
    required this.apiService,
    required this.allocationBloc,
    required this.allocation,
    required this.onBack,
    required this.onAllocationUpdated,
  }) : super(key: key);

  @override
  State<EditAllocationScreen> createState() => _EditAllocationScreenState();
}

class _EditAllocationScreenState extends State<EditAllocationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;

  String status = "Active";
  String? selectedSupervisor;
  String? selectedProject;
  String? selectedSite;
  DateTime? fromDate;
  DateTime? toDate;

  List<EmployeeList> allEmployees = [];
  List<String> selectedEmployeeIds = [];

  late EditAllocationBloc _editAllocationBloc;

  @override
  void initState() {
    super.initState();
    _editAllocationBloc = EditAllocationBloc(apiService: widget.apiService);

    final a = widget.allocation;
    _idController = TextEditingController(text: a.allocationid ?? '');
    selectedSupervisor = a.supervisorname;
    selectedProject = a.projectname;
    selectedSite = a.sitename;
    status = a.status ?? "Active";

    if (a.fromDate != null && a.fromDate!.isNotEmpty) {
      fromDate = DateTime.tryParse(a.fromDate!);
    }
    if (a.toDate != null && a.toDate!.isNotEmpty) {
      toDate = DateTime.tryParse(a.toDate!);
    }

    if (a.employee != null && a.employee!.isNotEmpty) {
      selectedEmployeeIds = a.employee!
          .map((e) => e.id?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    }
  }

  @override
  void dispose() {
    _editAllocationBloc.close();
    _idController.dispose();
    super.dispose();
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.allocationBloc),
        BlocProvider(create: (_) => _editAllocationBloc),
        BlocProvider(create: (_) => SupervisorBloc(widget.apiService)..add(FetchSupervisorsEvent())),
        BlocProvider(create: (_) => ProjectBloc(widget.apiService)..add(FetchProjectEvent())),
        BlocProvider(create: (_) => SiteBloc(widget.apiService)..add(FetchSiteEvent())),
        BlocProvider(create: (_) => EmployeeBloc(widget.apiService)..add(FetchEmployeeEvent())),
      ],
      child: BlocListener<EditAllocationBloc, EditAllocationState>(
        listener: (context, state) {
          if (state is EditAllocationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            widget.allocationBloc.add(FetchAllocationEvent());
            widget.onAllocationUpdated();
            widget.onBack();
          } else if (state is EditAllocationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.primaryLight,
          body: Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))
                ],
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Edit Allocation",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.primary),
                      ),
                      const SizedBox(height: 24),

                      _buildTextField("Allocation ID", _idController, enabled: false),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(child: _buildProjectDropdown()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildSiteDropdown()),
                        ],
                      ),

                      const SizedBox(height: 16),
                      _buildEmployeeDropdown(),

                      const SizedBox(height: 16),
                      _buildSupervisorDropdown(),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePickerWidget(
                              labelText: "From Date",
                              selectedDate: fromDate,
                              onDateSelected: (picked) => setState(() => fromDate = picked),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDatePickerWidget(
                              labelText: "To Date",
                              selectedDate: toDate,
                              onDateSelected: (picked) => setState(() => toDate = picked),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      CustomDropdownWidget(
                        valArr: const ["Active", "Inactive"],
                        selectedItem: status,
                        labelText: "Status",
                        onChanged: (v) => setState(() => status = v),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<EditAllocationBloc, EditAllocationState>(
                            builder: (context, state) {
                              final isLoading = state is EditAllocationLoading;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                onPressed: isLoading ? null : _onUpdatePressed,
                                child: isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text("Update", style: TextStyle(color: Colors.white)),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: widget.onBack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ FIXED EMPLOYEE DROPDOWN (No duplicate entries)
//  Widget _buildEmployeeDropdown() {
//   return BlocBuilder<EmployeeBloc, EmployeeState>(
//     builder: (context, state) {
//       if (state is EmployeeLoaded) {
//         // 1️⃣ API employees — only for dropdown
//         final apiEmployees = List<EmployeeList>.from(state.employee);

//         // 2️⃣ Employees already added in allocation (for chips)
//         final allocationEmployees = (widget.allocation.employee ?? [])
//             .map((emp) => EmployeeList(
//                   id: emp.id,
//                   employeename: emp.employeename,
//                   employeeid: emp.employeeid,
//                 ))
//             .toList();

//         // 3️⃣ Final: dropdown shows only API employees
//         allEmployees = apiEmployees;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🔹 Dropdown shows only EmployeeBloc data
//             DropdownSearch<EmployeeList>.multiSelection(
//               items: allEmployees,
//               selectedItems: [],
//               itemAsString: (EmployeeList item) => item.employeename ?? '',
//               popupProps: PopupPropsMultiSelection.menu(
//                 showSearchBox: true,
//                 fit: FlexFit.loose,
//                 constraints: const BoxConstraints(maxHeight: 300),
//               ),
//               dropdownDecoratorProps: DropDownDecoratorProps(
//                 dropdownSearchDecoration: InputDecoration(
//                   labelText: "Select Employees",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               onChanged: (List<EmployeeList> selectedList) {
//                 setState(() {
//                   // Store only selected employee IDs
//                   selectedEmployeeIds =
//                       selectedList.map((e) => e.id.toString()).toList();
//                 });
//               },
//             ),

//             const SizedBox(height: 8),

//             /// 🔹 Chips show only allocation employees
//             if (allocationEmployees.isNotEmpty) ...[
//               const Text(
//                 "Already Allocated Employees:",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Wrap(
//                 spacing: 6,
//                 children: allocationEmployees.map((emp) {
//                   return Chip(
//                     label: Text(emp.employeename ?? ''),
//                     onDeleted: () {
//                       setState(() {
//                         widget.allocation.employee?.removeWhere(
//                             (e) => e.id.toString() == emp.id.toString());
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         );
//       } else if (state is EmployeeLoading) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (state is EmployeeError) {
//         return Text("Error: ${state.message}");
//       }
//       return const SizedBox();
//     },
//   );
// }

Widget _buildEmployeeDropdown() {
  return BlocBuilder<EmployeeBloc, EmployeeState>(
    builder: (context, state) {
      if (state is EmployeeLoaded) {
        // 1️⃣ Employees from API (for dropdown)
        final apiEmployees = List<EmployeeList>.from(state.employee);

        // 2️⃣ Employees already added in allocation (for chips + preselect)
        final allocationEmployees = (widget.allocation.employee ?? [])
            .map((emp) => EmployeeList(
                  id: emp.id,
                  employeename: emp.employeename,
                  employeeid: emp.employeeid,
                ))
            .toList();

        // 3️⃣ Remove duplicates (in case same employee appears in both)
        final existingIds = allocationEmployees.map((e) => e.id?.toString()).toSet();
        final uniqueApi = apiEmployees
            .where((e) => !existingIds.contains(e.id?.toString()))
            .toList();

        // 4️⃣ Merge unique API + allocation employees
        allEmployees = [...allocationEmployees, ...uniqueApi];

        // 5️⃣ Preselect employees that are already in allocation
        final selectedObjects = allEmployees
            .where((e) => selectedEmployeeIds.contains(e.id.toString()))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Dropdown showing all employees (API + allocated)
            DropdownSearch<EmployeeList>.multiSelection(
              items: allEmployees,
              selectedItems: selectedObjects, // 👈 preselect existing ones
              itemAsString: (EmployeeList item) => item.employeename ?? '',
              popupProps: PopupPropsMultiSelection.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 300),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select Employees",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onChanged: (List<EmployeeList> selectedList) {
                setState(() {
                  selectedEmployeeIds =
                      selectedList.map((e) => e.id.toString()).toList();
                });
              },
            ),

            const SizedBox(height: 12),

            /// 🔹 Show chips for already allocated employees
            if (allocationEmployees.isNotEmpty) ...[
              const Text(
                "Already Allocated Employees:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: allocationEmployees.map((emp) {
                  return Chip(
                    label: Text(emp.employeename ?? ''),
                    onDeleted: () {
                      setState(() {
                        widget.allocation.employee?.removeWhere(
                            (e) => e.id.toString() == emp.id.toString());
                        selectedEmployeeIds.remove(emp.id.toString());
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        );
      } else if (state is EmployeeLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is EmployeeError) {
        return Text("Error: ${state.message}");
      }
      return const SizedBox();
    },
  );
}


  Widget _buildProjectDropdown() {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoaded) {
          final projects = List<Projectlist>.from(state.project);
          if (selectedProject != null &&
              selectedProject!.isNotEmpty &&
              !projects.any((p) => p.projectname == selectedProject)) {
            projects.insert(0, Projectlist(projectname: selectedProject));
          }
          return CustomDropdownWidget(
            labelText: "Project",
            valArr: projects,
            selectedItem: projects.firstWhere(
              (p) => p.projectname == selectedProject,
              orElse: () => projects.first,
            ),
            labelField: (p) => p.projectname ?? '',
            onChanged: (v) => setState(() => selectedProject = v.projectname),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildSiteDropdown() {
    return BlocBuilder<SiteBloc, SiteState>(
      builder: (context, state) {
        if (state is SiteLoaded) {
          final sites = List<Sitelist>.from(state.site);
          if (selectedSite != null &&
              selectedSite!.isNotEmpty &&
              !sites.any((s) => s.sitename == selectedSite)) {
            sites.insert(0, Sitelist(sitename: selectedSite));
          }
          return CustomDropdownWidget(
            labelText: "Site",
            valArr: sites,
            selectedItem: sites.firstWhere(
              (s) => s.sitename == selectedSite,
              orElse: () => sites.first,
            ),
            labelField: (s) => s.sitename ?? '',
            onChanged: (v) => setState(() => selectedSite = v.sitename),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildSupervisorDropdown() {
    return BlocBuilder<SupervisorBloc, SupervisorState>(
      builder: (context, state) {
        if (state is SupervisorLoaded) {
          final supervisors = List<Supervisorlist>.from(state.supervisors);
          if (selectedSupervisor != null &&
              selectedSupervisor!.isNotEmpty &&
              !supervisors.any((s) => s.supervisorname == selectedSupervisor)) {
            supervisors.insert(0, Supervisorlist(supervisorname: selectedSupervisor));
          }
          return CustomDropdownWidget(
            labelText: "Supervisor",
            valArr: supervisors,
            selectedItem: supervisors.firstWhere(
              (s) => s.supervisorname == selectedSupervisor,
              orElse: () => supervisors.first,
            ),
            labelField: (s) => s.supervisorname ?? '',
            onChanged: (v) => setState(() => selectedSupervisor = v.supervisorname),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onUpdatePressed() {
    if (_formKey.currentState!.validate()) {
      final employeeListToSend = allEmployees
          .where((e) => selectedEmployeeIds.contains(e.id.toString()))
          .map((e) => {
                "id": e.id,
                "employeeid": e.employeeid,
                "employeename": e.employeename,
              })
          .toList();

      final payload = {
        "id": widget.allocation.id.toString(),
        "allocationid": widget.allocation.allocationid.toString(),
        "supervisorname": selectedSupervisor,
        "projectname": selectedProject,
        "sitename": selectedSite,
        "fromDate": formatDate(fromDate),
        "toDate": formatDate(toDate),
        "status": status,
        "employee": employeeListToSend,
        "syncstaus": null
      };

      print("📤 PUT payload => $payload");

      _editAllocationBloc.add(
        SubmitEditAllocation(
          id: widget.allocation.id.toString(),
          status: status,
          supervisorname: selectedSupervisor ?? '',
          projectname: selectedProject ?? '',
          sitename: selectedSite ?? '',
          fromDate: formatDate(fromDate),
          toDate: formatDate(toDate),
          employee: employeeListToSend,
          allocationid: widget.allocation.allocationid.toString(),
        ),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
