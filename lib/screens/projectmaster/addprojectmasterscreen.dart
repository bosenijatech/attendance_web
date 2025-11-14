import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../bloc/bloc/projectmaster/addproject_bloc.dart';
import '../../bloc/bloc/projectmaster/project_bloc.dart';

import '../../bloc/event/projectmaster/addproject_event.dart';
import '../../bloc/event/projectmaster/project_event.dart';

import '../../bloc/state/projectmaster/addproject_state.dart';
import '../../bloc/state/projectmaster/project_state.dart';
import '../../model/projectmaster/getallprojectmodel.dart';

import '../../services/attendance_apiservice.dart';
import '../../constant/app_color.dart';
import '../../widgets/custom_dropdown.dart';

class Addprojectmasterscreen extends StatefulWidget {
  final AttendanceApiService apiService;
  final ProjectBloc projectBloc;
  final VoidCallback? onBack;

  const Addprojectmasterscreen({
    Key? key,
    required this.apiService,
    required this.projectBloc,
    this.onBack,
  }) : super(key: key);

  @override
  State<Addprojectmasterscreen> createState() => _AddprojectmasterscreenState();
}

class _AddprojectmasterscreenState extends State<Addprojectmasterscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String status = "Active";
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    widget.projectBloc.add(FetchProjectEvent());
  }

  void _setNextProjectId(List<Projectlist> project) {
    int maxId = 0;
    for (var s in project) {
      final numeric = s.projectid!.replaceAll(RegExp(r'[^0-9]'), '');
      final n = int.tryParse(numeric) ?? 0;
      if (n > maxId) maxId = n;
    }
    _idController.text = "P${(maxId + 1).toString().padLeft(3, '0')}";
  }

  void _saveProject(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _saved = true;
      context.read<AddProjectBloc>().add(
        CreateProjectEvent(
          projectId: _idController.text.trim(),
          projectName: _nameController.text.trim(),

          status: status,
          id: '',
          projectAddress: _addressController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.projectBloc),
        BlocProvider(
          create: (_) => AddProjectBloc(apiService: widget.apiService),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddProjectBloc, AddProjectState>(
            listener: (context, state) {
              if (state is AddProjectSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${state.model.data?.projectname ?? 'Project'} added successfully",
                    ),
                  ),
                );

                // ✅ Refresh Project list
                widget.projectBloc.add(FetchProjectEvent());
              } else if (state is AddProjectFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectLoaded) {
                _setNextProjectId(state.project);
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
                      "Add Project",
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
                            "Project ID",
                            _idController,
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            "Project Name",
                            _nameController,
                            validator: (v) => v!.isEmpty ? "Enter name" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      "Project Address",
                      _addressController,
                      validator: (v) =>
                          v!.isEmpty ? "Enter address" : null,
                    ),
                    const SizedBox(width: 12),
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
                        BlocBuilder<AddProjectBloc, AddProjectState>(
                          builder: (context, state) {
                            if (state is AddProjectLoading) {
                              return const CircularProgressIndicator();
                            }
                            return ElevatedButton(
                              onPressed: () => _saveProject(context),
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
