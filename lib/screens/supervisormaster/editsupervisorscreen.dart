


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/bloc/supervisor/editsupervisor_bloc.dart';
import '../../bloc/bloc/supervisor/supervisor_bloc.dart';
import '../../bloc/event/supervisor/editsupervisor_event.dart';
import '../../bloc/event/supervisor/supervisor_event.dart';
import '../../bloc/state/supervisor/editsupervisor_state.dart';
import '../../constant/utils.dart';
import '../../services/attendance_apiservice.dart';
import '../../model/supervisor/getallsupervisormodel.dart';
import '../../constant/app_color.dart';
import '../../widgets/custom_dropdown.dart';

class EditSupervisorScreen extends StatefulWidget {
  final SupervisorBloc supervisorBloc;
  final Supervisorlist supervisor;
  final VoidCallback onBack;

  const EditSupervisorScreen({
    super.key,
    required this.supervisor,
    required this.onBack,
    required AttendanceApiService apiService,
    required Null Function() onSupervisorUpdated,
    required this.supervisorBloc,
  });

  @override
  State<EditSupervisorScreen> createState() => _EditSupervisorScreenState();
}

class _EditSupervisorScreenState extends State<EditSupervisorScreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late String type;
  late String status;
  late EditSupervisorBloc _editSupervisorBloc;
 final role =  SharedPrefs.getUserRole();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    idController =
        TextEditingController(text: widget.supervisor.supervisorid ?? '');
    nameController =
        TextEditingController(text: widget.supervisor.supervisorname ?? '');
    usernameController =
        TextEditingController(text: widget.supervisor.username ?? '');
    passwordController =
        TextEditingController(text: widget.supervisor.password ?? '');
    type = widget.supervisor.type ?? "Supervisor";

    String normalizedStatus =
        (widget.supervisor.status ?? '').toLowerCase().trim();
    status = (normalizedStatus == "active" || normalizedStatus == "inactive")
        ? normalizedStatus[0].toUpperCase() + normalizedStatus.substring(1)
        : "Active";

    _editSupervisorBloc = EditSupervisorBloc(apiService: AttendanceApiService());
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    _editSupervisorBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _editSupervisorBloc,
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
                    offset: Offset(0, 6))
              ],
            ),
            child: BlocConsumer<EditSupervisorBloc, EditSupervisorState>(
              listener: (context, state) {
                if (state is EditSupervisorSuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));

                  // ✅ Refresh supervisor list
                  widget.supervisorBloc.add(FetchSupervisorsEvent());
                  widget.onBack();
                } else if (state is EditSupervisorFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Edit Supervisor",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Row 1 - ID + Name
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: idController,
                              decoration: const InputDecoration(
                                labelText: "Supervisor ID",
                                border: OutlineInputBorder(),
                                   enabled: false,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Supervisor Name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Row 2 - Username + Password (with eye)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Row 3 - Type + Status
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownWidget(
                              valArr: const ["Supervisor", "Admin"],
                              selectedItem: type,
                              labelText: "Type",
                              validator: (v) =>
                                  v == null ? "Please select a type" : null,
                              onChanged: (value) {
                                setState(() {
                                  type = value ?? "Supervisor";
                                });
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
                                setState(() {
                                  status = value ?? "Active";
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 🔹 Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          onPressed: state is EditSupervisorLoading
    ? null
    : () async {
        


        // ✅ If admin, allow update
        _editSupervisorBloc.add(
          SubmitEditSupervisor(
            id: widget.supervisor.id ?? '0',
            supervisorId: idController.text,
            supervisorName: nameController.text,
            type: type,
            status: status,
            username: usernameController.text,
            password: passwordController.text,
          ),
        );
      },

                            child: state is EditSupervisorLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text("Update",
                                    style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: widget.onBack,
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
