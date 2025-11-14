import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../bloc/bloc/employee/editemployeer_bloc.dart';
import '../../bloc/bloc/employee/employee_bloc.dart';
import '../../bloc/event/employee/editemployee_event.dart';
import '../../bloc/event/employee/employee_event.dart';
import '../../bloc/state/employee/editemployee_state.dart';
import '../../constant/app_color.dart';
import '../../model/employee/getallemployeemodel.dart';
import '../../services/attendance_apiservice.dart';
import '../../widgets/custom_dropdown.dart';

class Editemployeescreen extends StatefulWidget {
  final EmployeeBloc employeeBloc;
  final EmployeeList employee;
  final VoidCallback onBack;

  const Editemployeescreen({
    super.key,
    required this.employee,
    required this.onBack,
    required AttendanceApiService apiService,
    required Null Function() onEmployeeUpdated,
    required this.employeeBloc,
  });

  @override
  State<Editemployeescreen> createState() => _EditemployeescreenState();
}

class _EditemployeescreenState extends State<Editemployeescreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late String type;
  late String status;
  late EditEmployeeBloc _editEmployeeBloc;

  @override
  void initState() {
    super.initState();

    idController = TextEditingController(
      text: widget.employee.employeeid ?? '',
    );
    nameController = TextEditingController(
      text: widget.employee.employeename ?? '',
    );
    type = widget.employee.type ?? "Employee";

    String normalizedStatus = (widget.employee.status ?? '')
        .toLowerCase()
        .trim();
    status = (normalizedStatus == "active" || normalizedStatus == "inactive")
        ? normalizedStatus[0].toUpperCase() + normalizedStatus.substring(1)
        : "Active";

    _editEmployeeBloc = EditEmployeeBloc(apiService: AttendanceApiService());
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    _editEmployeeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _editEmployeeBloc,
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
            child: BlocConsumer<EditEmployeeBloc, EditEmployeeState>(
              listener: (context, state) {
                if (state is EditEmployeeSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  // ✅ Refresh Employee list
                  widget.employeeBloc.add(FetchEmployeeEvent());
                  widget.onBack();
                } else if (state is EditEmployeeFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Edit Employee",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: idController,
                            decoration: const InputDecoration(
                              labelText: "Employee ID",
                              border: OutlineInputBorder(),
                            ),
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Employee Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownWidget(
                            valArr: const [
                              "Permanent",
                              "Temporary",
                              "Contract",
                            ],
                            selectedItem: type,
                            labelText: "Type",
                            validator: (v) =>
                                v == null ? "Please select a Type" : null,
                            onChanged: (value) {
                              setState(() => type = value);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomDropdownWidget(
                            valArr: const ["Active", "Inactive"],
                            selectedItem: status,
                            labelText: "Status",
                            validator: (v) =>
                                v == null ? "Please select a status" : null,
                            onChanged: (value) {
                              setState(() => status = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
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
                          onPressed: state is EditEmployeeLoading
                              ? null
                              : () {
                                  _editEmployeeBloc.add(
                                    SubmitEditEmployee(
                                      id:
                                          widget.employee.id ??
                                          '0', // numeric DB ID
                                      employeeId: idController.text,
                                      employeeName: nameController.text,
                                      type: type,
                                      status: status,
                                      employeeemail: '',
                                    ),
                                  );
                                },
                          child: state is EditEmployeeLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
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
                          onPressed: widget.onBack,
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
