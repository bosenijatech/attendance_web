




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../bloc/bloc/employee/addemployee_bloc.dart';
import '../../bloc/bloc/employee/employee_bloc.dart';
import '../../bloc/event/employee/addemployee_event.dart';
import '../../bloc/event/employee/employee_event.dart';
import '../../bloc/state/employee/addemployee_state.dart';
import '../../bloc/state/employee/employee_state.dart';
import '../../model/employee/getallemployeemodel.dart';
import '../../services/attendance_apiservice.dart';
import '../../constant/app_color.dart';
import '../../widgets/custom_dropdown.dart';

class AddemployeeScreen extends StatefulWidget {
  final AttendanceApiService apiService;
  final EmployeeBloc employeeBloc;
  final VoidCallback? onBack;

  const AddemployeeScreen({
    Key? key,
    required this.apiService,
    required this.employeeBloc,
    this.onBack,
  }) : super(key: key);

  @override
  State<AddemployeeScreen> createState() => _AddemployeeScreenState();
}

class _AddemployeeScreenState extends State<AddemployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String type = "Permanent";
  String status = "Active";
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    print("🔹 AddEmployeeScreen initialized");
    widget.employeeBloc.add(FetchEmployeeEvent());
  }

  void _setNextEmployeeId(List<EmployeeList> employee) {
    int maxId = 0;
    for (var s in employee) {
      final numeric = s.employeeid!.replaceAll(RegExp(r'[^0-9]'), '');
      final n = int.tryParse(numeric) ?? 0;
      if (n > maxId) maxId = n;
    }
    final newId = "EMP${(maxId + 1).toString().padLeft(3, '0')}";
    print("🧩 Latest Employee ID generated: $newId");
    _idController.text = newId;
  }

  void _saveEmployee(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      print("✅ Saving employee...");
      print("➡ ID: ${_idController.text}");
      print("➡ Name: ${_nameController.text}");
      print("➡ Type: $type");
      print("➡ Status: $status");

      _saved = true;
      context.read<AddEmployeeBloc>().add(
            CreateEmployeeEvent(
              employeeId: _idController.text.trim(),
              employeeName: _nameController.text.trim(),
              type: type,
              status: status,
              id: '', employeeemail: _emailController.text.trim(),
            ),
          );
    } else {
      print("❌ Validation failed. Please fill required fields.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.employeeBloc),
        BlocProvider(create: (_) => AddEmployeeBloc(apiService: widget.apiService)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddEmployeeBloc, AddEmployeeState>(
            listener: (context, state) {
              if (state is AddEmployeeSuccess) {
                print("🎉 Employee added successfully: ${state.model.data?.employeename}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${state.model.data?.employeename ?? 'Employee'} added successfully"),
                  ),
                );
                widget.employeeBloc.add(FetchEmployeeEvent());
              } else if (state is AddEmployeeFailure) {
                print("❌ Failed to add employee: ${state.error}");
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeLoaded) {
                print("📋 Employee list loaded: ${state.employee.length} employees");
                _setNextEmployeeId(state.employee);
                if (_saved) {
                  print("⬅️ Navigating back after successful save");
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add Employee",
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
                          child: _buildTextField("Employee ID", _idController, enabled: false),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            "Employee Name",
                            _nameController,
                            validator: (v) => v!.isEmpty ? "Enter name" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      "Employee Email",
                      _emailController,
                      validator: (v) => v!.isEmpty ? "Enter Mail" : null,
                    ),
                            const SizedBox(height: 16),
                    Row(
                      children: [
                           
                          
                        Expanded(
                          child: 
                          
                          CustomDropdownWidget(
                                                      valArr: const ["Permanent", "Temporary","Contract"],
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
                          child: 
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocBuilder<AddEmployeeBloc, AddEmployeeState>(
                          builder: (context, state) {
                            if (state is AddEmployeeLoading) {
                              print("⏳ Adding employee...");
                              return const CircularProgressIndicator();
                            }
                            return ElevatedButton(
                              onPressed: () => _saveEmployee(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: const Text("Save", style: TextStyle(color: Colors.white)),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            print("❎ Cancel pressed — navigating back");
                            widget.onBack?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
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
