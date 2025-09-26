

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../constant/app_color.dart';

// Models
import '../../model/supervisor/addsupervisormodel.dart';
import '../../model/supervisor/getallsupervisormodel.dart';

// Service
import '../../services/attendance_apiservice.dart';

class Editsupervisorscreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isEdit;
  final Supervisorlist? supervisor;
  final Function(Supervisorlist)? onSave;
  final Function(Supervisorlist)? onAdd;
  final List<Supervisorlist>?
  allSupervisors; // Pass all supervisors for next ID

  const Editsupervisorscreen({
    super.key,
    this.onBack,
    this.isEdit = false,
    this.supervisor,
    this.onAdd,
    this.onSave,
    this.allSupervisors,
  });

  @override
  State<Editsupervisorscreen> createState() => _EditsupervisorscreenState();
}

class _EditsupervisorscreenState extends State<Editsupervisorscreen> {
  final AttendanceApiService apiService = AttendanceApiService();
  bool isLoading = false;

  late TextEditingController supervisorIdController;
  late TextEditingController supervisorNameController;

  String status = "Active";
  String type = "Supervisor";

  @override
  void initState() {
    super.initState();

    // Calculate next supervisor ID
    String nextId = widget.isEdit
        ? (widget.supervisor?.supervisorid ?? 'S001')
        : generateNextId(widget.allSupervisors ?? []);

    supervisorIdController = TextEditingController(text: nextId);
    supervisorNameController = TextEditingController(
      text: widget.supervisor?.supervisorname ?? '',
    );
    type = widget.supervisor?.type ?? 'Supervisor';
    status = widget.supervisor?.status ?? 'Active';
  }

  @override
  void dispose() {
    supervisorIdController.dispose();
    supervisorNameController.dispose();
    super.dispose();
  }

  // Generate next ID from list
  String generateNextId(List<Supervisorlist> supervisors) {
    if (supervisors.isEmpty) return 'S001';

    supervisors.sort((a, b) {
      final aNum = int.parse(a.supervisorid!.substring(1));
      final bNum = int.parse(b.supervisorid!.substring(1));
      return aNum.compareTo(bNum);
    });

    final lastId = supervisors.last.supervisorid!;
    final nextNum = int.parse(lastId.substring(1)) + 1;
    return 'S ${nextNum.toString().padLeft(3, '0')}';
  }

Future<void> AddSupervisor({
  required String supervisorId,
  required String supervisorName,
  required String type,
  required String status,
}) async {
  setState(() => isLoading = true);

  final postData = {
    "supervisorid": supervisorId,
    "supervisorname": supervisorName,
    "type": type,
    "status": status,
  };

  print("📤 Sending Add Supervisor Request: $postData");

  try {
    final response = await apiService.AddSupervisor(postData);
    final Map<String, dynamic> responseData = jsonDecode(response);
    final model = AddsupervisorsModel.fromJson(responseData);

    if (model.status) {
      final addedSupervisor = Supervisorlist(
        id: model.data?.id ?? '',
        supervisorid: supervisorIdController.text.trim(),
        supervisorname: supervisorNameController.text.trim(),
        type: type,
        status: status,
      );
print(addedSupervisor);
      widget.onAdd?.call(addedSupervisor);
      widget.onBack?.call();
      print("✅ Supervisor added successfully: $addedSupervisor");
    } else {
      print("❌ Failed to add supervisor: ${model.message}");
    }
  } catch (e) {
    print("❌ Error adding supervisor: $e");
  } finally {
    setState(() => isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isEdit
                    ? "Edit Supervisor Master"
                    : "Add Supervisor Master",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Fields
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      "Supervisor ID",
                      supervisorIdController,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildTextField(
                      "Supervisor Name",
                      supervisorNameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Type
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: type,
                  items: const [
                    DropdownMenuItem(
                      value: "Supervisor",
                      child: Text("Supervisor"),
                    ),
                    DropdownMenuItem(
                      value: "Employee",
                      child: Text("Employee"),
                    ),
                  ],
                  onChanged: (value) => setState(() => type = value!),
                  buttonStyleData: const ButtonStyleData(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.grey),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Status
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: status,
                  items: const [
                    DropdownMenuItem(value: "Active", child: Text("Active")),
                    DropdownMenuItem(
                      value: "Inactive",
                      child: Text("Inactive"),
                    ),
                  ],
                  onChanged: (value) => setState(() => status = value!),
                  buttonStyleData: const ButtonStyleData(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.grey),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
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
              onPressed: () {
  if (supervisorNameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter supervisor name')),
    );
    return;
  }

  if (widget.isEdit) {
    // Call your update function here (if implemented)
  } else {
    AddSupervisor(
      supervisorId: supervisorIdController.text.trim(),
      supervisorName: supervisorNameController.text.trim(),
      type: type,
      status: status,
    );
    
  }
},
                    child: Text(
                      widget.isEdit ? "Save" : "Add",
                      style: const TextStyle(color: AppColor.white),
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
                      style: TextStyle(color: AppColor.white),
                    ),
                  ),
                ],
              ),

              if (isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(color: AppColor.primary),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return TextField(
      enabled: enabled,
      cursorColor: AppColor.primary,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary),
        ),
        floatingLabelStyle: const TextStyle(color: AppColor.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
