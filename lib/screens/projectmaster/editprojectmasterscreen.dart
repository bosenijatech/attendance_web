import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../bloc/bloc/projectmaster/editproject_bloc.dart';
import '../../bloc/bloc/projectmaster/project_bloc.dart';




import '../../bloc/event/projectmaster/editproject_event.dart';
import '../../bloc/event/projectmaster/project_event.dart';
import '../../bloc/state/projectmaster/editproject_state.dart';
import '../../model/projectmaster/getallprojectmodel.dart';

import '../../services/attendance_apiservice.dart';

import '../../constant/app_color.dart';
import '../../widgets/custom_dropdown.dart';

class Editprojectmasterscreen extends StatefulWidget {
  final ProjectBloc projectBloc;
  final Projectlist project;
  final VoidCallback onBack;

  const Editprojectmasterscreen({
    super.key,
    required this.project,
    required this.onBack, required AttendanceApiService apiService, required Null Function() onProjectUpdated, required this.projectBloc, 
  });

  @override
  State<Editprojectmasterscreen> createState() => _EditprojectmasterscreenState();
}

class _EditprojectmasterscreenState extends State<Editprojectmasterscreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController addressController;
 

  late String status;
  late EditProjectBloc _editProjectBloc;

  @override
  void initState() {
    super.initState();

    idController = TextEditingController(text: widget.project.projectid ?? '');
    nameController = TextEditingController(text: widget.project.projectname ?? '');
    
    addressController = TextEditingController(text: widget.project.projectaddress ?? '');

  

    String normalizedStatus = (widget.project.status ?? '').toLowerCase().trim();
    status = (normalizedStatus == "active" || normalizedStatus == "inactive")
        ? normalizedStatus[0].toUpperCase() + normalizedStatus.substring(1)
        : "Active";

    _editProjectBloc = EditProjectBloc(apiService: AttendanceApiService());
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    _editProjectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _editProjectBloc,
      child: Scaffold(
        backgroundColor: AppColor.primaryLight,
        body: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
            ),
            child: BlocConsumer<EditProjectBloc, EditProjectState>(
              listener: (context, state) {
                if (state is EditProjectSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                   // ✅ Refresh supervisor list
                widget.projectBloc.add(FetchProjectEvent());
                  widget.onBack();
                } else if (state is EditProjectFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Edit Project", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.primary)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: idController,
                            decoration: const InputDecoration(labelText: "Project ID", border: OutlineInputBorder()),
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: "Project Name", border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: "Project Address", border: OutlineInputBorder()),
                     
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: state is EditProjectLoading
                              ? null
                              : () {
                                  _editProjectBloc.add(
                                    SubmitEditProject(
                                      id: widget.project.id ?? '0', // numeric DB ID
                                      projectId: idController.text,
                                    projectName: nameController.text,
                                     projectAddress: addressController.text,
                                    
                                      status: status,
                                    ),
                                  );
                                },
                          child: state is EditProjectLoading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text("Save", style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: widget.onBack,
                          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
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
