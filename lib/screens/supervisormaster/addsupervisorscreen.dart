import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../bloc/bloc/supervisor/addsupervisor_bloc.dart';
import '../../bloc/event/supervisor/addsupervisor_event.dart';
import '../../bloc/state/supervisor/addsupervisor_state.dart';
import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
import '../../bloc/event/supervisor/supervisor_event.dart';
import '../../bloc/state/supervisor/supervisor_state.dart';
import '../../services/attendance_apiservice.dart';
import '../../constant/app_color.dart';
import '../../model/supervisor/getallsupervisormodel.dart';
import '../../widgets/custom_dropdown.dart';

class AddSupervisorScreen extends StatefulWidget {
  final AttendanceApiService apiService;
  final SupervisorBloc supervisorBloc;
  final VoidCallback? onBack;

  const AddSupervisorScreen({
    Key? key,
    required this.apiService,
    required this.supervisorBloc,
    this.onBack,
  }) : super(key: key);

  @override
  State<AddSupervisorScreen> createState() => _AddSupervisorScreenState();
}

class _AddSupervisorScreenState extends State<AddSupervisorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String type = "Supervisor";
  String status = "Active";
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    widget.supervisorBloc.add(FetchSupervisorsEvent());
  }

  void _setNextSupervisorId(List<Supervisorlist> supervisors) {
    int maxId = 0;
    for (var s in supervisors) {
      final numeric = s.supervisorid!.replaceAll(RegExp(r'[^0-9]'), '');
      final n = int.tryParse(numeric) ?? 0;
      if (n > maxId) maxId = n;
    }
    _idController.text = "SUP${(maxId + 1).toString().padLeft(3, '0')}";
  }

  void _saveSupervisor(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _saved = true;
      context.read<AddSupervisorBloc>().add(
        CreateSupervisorEvent(
          supervisorId: _idController.text.trim(),
          supervisorName: _nameController.text.trim(),
          type: type,
          status: status,
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          id: '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.supervisorBloc),
        BlocProvider(
          create: (_) => AddSupervisorBloc(apiService: widget.apiService),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddSupervisorBloc, AddSupervisorState>(
            listener: (context, state) {
              if (state is AddSupervisorSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${state.model.data?.supervisorname ?? 'Supervisor'} added successfully",
                    ),
                  ),
                );

                // ✅ Refresh supervisor list
                widget.supervisorBloc.add(FetchSupervisorsEvent());
              } else if (state is AddSupervisorFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<SupervisorBloc, SupervisorState>(
            listener: (context, state) {
              if (state is SupervisorLoaded) {
                _setNextSupervisorId(state.supervisors);
                if (_saved) {
                  widget.onBack?.call(); // ✅ Go back after save
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
                      "Add Supervisor",
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
                          child: _buildTextField(
                            "Supervisor ID",
                            _idController,
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            "Supervisor Name",
                            _nameController,
                            validator: (v) => v!.isEmpty ? "Enter name" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                          Expanded(
                          child: _buildTextField(
                            "User Name",
                            usernameController,
                            validator: (v) => v!.isEmpty ? "Enter username" : null,
                          ),
                        ),
                         const SizedBox(width: 12),
                             Expanded(
                          child: _buildTextField(
                            "Password",
                            passwordController,
                            validator: (v) => v!.isEmpty ? "Enter password" : null,
                          ),
                        ),
                      ],
                    ),
                         const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownWidget(
                            valArr: const ["Supervisor", "Admin"],
                            selectedItem: type,
                            labelText: "Status",
                            validator: (v) =>
                                v == null ? "Please select a type" : null,
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
                        BlocBuilder<AddSupervisorBloc, AddSupervisorState>(
                          builder: (context, state) {
                            if (state is AddSupervisorLoading) {
                              return const CircularProgressIndicator();
                            }
                            return ElevatedButton(
                              onPressed: () => _saveSupervisor(context),
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
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
