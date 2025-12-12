

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../bloc/bloc/allocation/addallocation_bloc.dart';
import '../../bloc/bloc/allocation/allocation_bloc.dart';
import '../../bloc/bloc/employee/employee_bloc.dart';
import '../../bloc/bloc/projectmaster/project_bloc.dart';
import '../../bloc/bloc/site/site_bloc.dart';
import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
import '../../bloc/event/allocation/addallocation_event.dart';
import '../../bloc/event/allocation/allocation_event.dart';
import '../../bloc/event/employee/employee_event.dart';
import '../../bloc/event/projectmaster/project_event.dart';
import '../../bloc/event/site/site_event.dart';
import '../../bloc/event/supervisor/supervisor_event.dart';
import '../../bloc/state/allocation/addallocation_state.dart';
import '../../bloc/state/allocation/allocation_state.dart';
import '../../bloc/state/employee/employee_state.dart';
import '../../bloc/state/projectmaster/project_state.dart';
import '../../bloc/state/site/site_state.dart';
import '../../bloc/state/supervisor/supervisor_state.dart';
import '../../model/allocation/getallallocationmodel.dart';
import '../../services/attendance_apiservice.dart';
import '../../constant/app_color.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/customdatepicker.dart';

class AddAllocationScreen extends StatefulWidget {
  final AttendanceApiService apiService;
  final AllocationBloc allocationBloc;
  final VoidCallback? onBack;

  const AddAllocationScreen({
    Key? key,
    required this.apiService,
    required this.allocationBloc,
    this.onBack,
  }) : super(key: key);

  @override
  State<AddAllocationScreen> createState() => _AddAllocationScreenState();
}

class _AddAllocationScreenState extends State<AddAllocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();

  String status = "Active";
  bool _saved = false;

  String? selectedSupervisorName;
  String? selectedSupervisorId;

  int? selectedsyncstaus;
  String? selectedEmployee;
  String? selectedSite;
  DateTime? fromDate;
  String? selectedProject;
  DateTime? toDate;
  List<String> selectedEmployees = [];

  @override
  void initState() {
    super.initState();
    widget.allocationBloc.add(FetchAllocationEvent());
  }

  void _setNextAllocationId(List<Allocationlist> allocation) {
    int maxId = 0;
    for (var s in allocation) {
      final numeric = s.allocationid?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0';
      final n = int.tryParse(numeric) ?? 0;
      if (n > maxId) maxId = n;
    }
    _idController.text = "ALLO${(maxId + 1).toString().padLeft(3, '0')}";
  }

  // 🔹 Convert DateTime → MM/DD/YYYY
  String formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  // ✅ FIXED FUNCTION — includes employee name + id
  void _saveAllocation(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (selectedSupervisorName == null ||
          selectedProject == null ||
          selectedSite == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select all dropdowns")),
        );
        return;
      }
      if (fromDate == null || toDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select From and To dates")),
        );
        return;
      }

      final formattedFrom = formatDate(fromDate!);
      final formattedTo = formatDate(toDate!);

      // 🔹 Get Employee list from EmployeeBloc
      final employeeState = context.read<EmployeeBloc>().state;
      List<Map<String, dynamic>> employeeList = [];

      if (employeeState is EmployeeLoaded) {
        for (var emp in employeeState.employee) {
          if (selectedEmployees.contains(emp.id)) {
            employeeList.add({
              "id": emp.id ?? '',
              "employeename": emp.employeename ?? '',
              "employeeid": emp.employeeid ?? '',
            });
          }
        }
      }


      _saved = true;

      context.read<AddAllocationBloc>().add(
        CreateAllocationEvent(
          id: '',
          
        supervisorid: selectedSupervisorId!,
          supervisorname: selectedSupervisorName!,
          projectname: selectedProject!,
          sitename: selectedSite!,
          fromDate: formattedFrom,
          toDate: formattedTo,
          status: status,
          employee: employeeList, 
           syncstaus: 0, allocationid: _idController.text.trim(), 
        
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.allocationBloc),
        BlocProvider(
          create: (_) => AddAllocationBloc(apiService: widget.apiService),
        ),
        BlocProvider(
          create: (_) =>
              SupervisorBloc(widget.apiService)..add(FetchSupervisorsEvent()),
        ),
        BlocProvider(
          create: (_) => SiteBloc(widget.apiService)..add(FetchSiteEvent()),
        ),
        BlocProvider(
          create: (_) =>
              ProjectBloc(widget.apiService)..add(FetchProjectEvent()),
        ),
        BlocProvider(
          create: (_) =>
              EmployeeBloc(widget.apiService)..add(FetchEmployeeEvent()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddAllocationBloc, AddAllocationState>(
            listener: (context, state) {
              if (state is AddAllocationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Allocation added successfully",
                    ),
                  ),
                );
                widget.allocationBloc.add(FetchAllocationEvent());
              } else if (state is AddAllocationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
          BlocListener<AllocationBloc, AllocationState>(
            listener: (context, state) {
              if (state is AllocationLoaded) {
                _setNextAllocationId(state.allocation);
                if (_saved) {
                  widget.onBack?.call();
                  _saved = false;
                }
              }
            },
          ),
        ],
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
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add Allocation",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildTextField("Allocation ID", _idController,
                          enabled: false),
                      const SizedBox(height: 16),

                      // 🔹 Project + Site
                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<ProjectBloc, ProjectState>(
                              builder: (context, state) {
                                if (state is ProjectLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is ProjectLoaded) {
                                  final projectList = state.project;
                                  return CustomDropdownWidget(
                                    labelText: "Project",
                                    valArr: projectList,
                                    selectedItem: selectedProject == null
                                        ? null
                                        : projectList.firstWhere(
                                            (s) =>
                                                s.projectname ==
                                                selectedProject,
                                            orElse: () => projectList.first,
                                          ),
                                    labelField: (s) => s.projectname ?? '',
                                    onChanged: (v) {
                                      setState(() {
                                        selectedProject = v.projectname;
                                      });
                                    },
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BlocBuilder<SiteBloc, SiteState>(
                              builder: (context, state) {
                                if (state is SiteLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is SiteLoaded) {
                                  final siteList = state.site;
                                  return CustomDropdownWidget(
                                    labelText: "Site",
                                    valArr: siteList,
                                    selectedItem: selectedSite == null
                                        ? null
                                        : siteList.firstWhere(
                                            (s) => s.sitename == selectedSite,
                                            orElse: () => siteList.first,
                                          ),
                                    labelField: (s) => s.sitename ?? '',
                                    onChanged: (v) {
                                      setState(() {
                                        selectedSite = v.sitename;
                                      });
                                    },
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 🔹 Employees (Multi Select)
          BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoaded) {
          final employees = state.employee;

          // Build selected employee objects for dropdown
          final selectedEmployeeObjects = employees
              .where((e) => selectedEmployees.contains(e.id?.toString()))
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownSearch<dynamic>.multiSelection(
                items: employees,
                selectedItems: selectedEmployeeObjects, // ✅ Reflect edit data
                itemAsString: (item) => item.employeename ?? '',
                popupProps: PopupPropsMultiSelection.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: const BoxConstraints(maxHeight: 300),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Employees",
                    floatingLabelStyle: const TextStyle(
                        fontSize: 16, color: AppColor.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onChanged: (List<dynamic> selectedList) {
                  setState(() {
                    selectedEmployees = selectedList
                        .map((e) => e.id?.toString() ?? '')
                        .toList();
                  });
                },
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: selectedEmployeeObjects.map((emp) {
                  return Chip(
                    label: Text(emp.employeename ?? ''),
                    onDeleted: () {
                      setState(() {
                        selectedEmployees.remove(emp.id?.toString());
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
        } else if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeError) {
          return Text("Error: ${state.message}");
        }
        return const SizedBox();
      },
    ),
                      const SizedBox(height: 16),

                      // 🔹 Supervisor Dropdown
                      // BlocBuilder<SupervisorBloc, SupervisorState>(
                      //   builder: (context, state) {
                      //     if (state is SupervisorLoading) {
                      //       return const Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     } else if (state is SupervisorLoaded) {
                      //       final supervisorList = state.supervisors;
                      //       return CustomDropdownWidget(
                      //         labelText: "Supervisor",
                      //         valArr: supervisorList,
                      //         selectedItem: selectedSupervisorName == null
                      //             ? null
                      //             : supervisorList.firstWhere(
                      //                 (s) =>
                      //                     s.supervisorname ==
                      //                     selectedSupervisorName,
                      //                 orElse: () => supervisorList.first,
                      //               ),
                      //         labelField: (s) => s.supervisorname ?? '',
                      //         onChanged: (v) {
                      //           setState(() {
                      //             selectedSupervisorName = v.supervisorname;
                                  
                      //           });
                      //         },
                      //       );
                      //     } else {
                      //       return const SizedBox();
                      //     }
                      //   },
                      // ),

                      BlocBuilder<SupervisorBloc, SupervisorState>(
  builder: (context, state) {
    if (state is SupervisorLoading) {
      return const Center(child: CircularProgressIndicator());
    } 
    else if (state is SupervisorLoaded) {
      final supervisorList = state.supervisors;

      return CustomDropdownWidget(
        labelText: "Supervisor",
        valArr: supervisorList,
        selectedItem: selectedSupervisorName == null
            ? null
            : supervisorList.firstWhere(
                (s) => s.supervisorname == selectedSupervisorName,
                orElse: () => supervisorList.first,
              ),
        labelField: (s) => s.supervisorname ?? '',
        onChanged: (v) {
          setState(() {
            selectedSupervisorName = v.supervisorname;
            selectedSupervisorId = v.id; 
             
          });
        },
      );
    } 
    else {
      return const SizedBox();
    }
  },
),

                      const SizedBox(height: 16),

                      // 🔹 From / To Date
                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePickerWidget(
                              labelText: "From Date",
                              selectedDate: fromDate,
                              onDateSelected: (picked) {
                                setState(() => fromDate = picked);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDatePickerWidget(
                              labelText: "To Date",
                              selectedDate: toDate,
                              onDateSelected: (picked) {
                                setState(() => toDate = picked);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      CustomDropdownWidget(
                        valArr: const ["Active", "Inactive"],
                        selectedItem: status,
                        labelText: "Status",
                        validator: (v) =>
                            v == null ? "Please select a status" : null,
                        onChanged: (value) {
                          setState(() => status = value);
                        },
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<AddAllocationBloc, AddAllocationState>(
                            builder: (context, state) {
                              if (state is AddAllocationLoading) {
                                return const CircularProgressIndicator();
                              }
                              return ElevatedButton(
                                onPressed: () => _saveAllocation(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: widget.onBack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}


