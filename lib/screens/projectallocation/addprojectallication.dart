


import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../constant/app_color.dart';
import 'projectallocation.dart';
import 'package:intl/intl.dart';

class Addprojectallicationscreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isEdit;
  final Allocation? allocation;
  final Function(Allocation)? onSave;
  final Function(Allocation)? onAdd;

  const Addprojectallicationscreen({
    super.key,
    this.onBack,
    this.isEdit = false,
    this.allocation,
    this.onAdd,
    this.onSave,
  });

  @override
  State<Addprojectallicationscreen> createState() =>
      _AddprojectallicationscreenState();
}

class _AddprojectallicationscreenState
    extends State<Addprojectallicationscreen> {
  late TextEditingController allocationNameController;
  late TextEditingController allocationSiteController;
  late TextEditingController allocationSupervisorController;

  String status = "Active";
  String? fromDate;
  String? toDate;

  @override
  void initState() {
    super.initState();

    allocationNameController =
        TextEditingController(text: widget.allocation?.projectName ?? '');
    allocationSiteController =
        TextEditingController(text: widget.allocation?.site ?? '');
    allocationSupervisorController =
        TextEditingController(text: widget.allocation?.supervisor ?? '');

    status = widget.allocation?.status ?? 'Active';

    // ✅ Always keep dates in dd-MM-yyyy format
    final now = DateTime.now();
    final defaultFrom = DateFormat('dd-MM-yyyy').format(now);
    final defaultTo =
        DateFormat('dd-MM-yyyy').format(now.add(const Duration(days: 30)));

    fromDate = widget.allocation?.fromdate ?? defaultFrom;
    toDate = widget.allocation?.todate ?? defaultTo;
  }

  @override
  void dispose() {
    allocationNameController.dispose();
    allocationSiteController.dispose();
    allocationSupervisorController.dispose();
    super.dispose();
  }

  void saveSite() {
    if (allocationNameController.text.isEmpty ||
        allocationSiteController.text.isEmpty ||
        allocationSupervisorController.text.isEmpty) {
      return;
    }

    final newAllocation = Allocation(
      projectName: allocationNameController.text,
      site: allocationSiteController.text,
      supervisor: allocationSupervisorController.text,
      status: status,
      fromdate: fromDate!,
      todate: toDate!,
    );

    if (widget.isEdit) {
      widget.onSave?.call(newAllocation);
    } else {
      widget.onAdd?.call(newAllocation);
    }
  }

  Future<void> pickDate(bool isFrom) async {
    DateTime initialDate = DateTime.now();

    // If already set, try parsing dd-MM-yyyy
    if (isFrom && fromDate != null) {
      initialDate = DateFormat('dd-MM-yyyy').parse(fromDate!);
    } else if (!isFrom && toDate != null) {
      initialDate = DateFormat('dd-MM-yyyy').parse(toDate!);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        if (isFrom) {
          fromDate = formattedDate;
        } else {
          toDate = formattedDate;
        }
      });
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
                    ? "Edit Project Allocation Master"
                    : "Add Project Allocation Master",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Fields
              buildTextField("Project Name", allocationNameController),
              const SizedBox(height: 12),
              buildTextField("Site", allocationSiteController),
              const SizedBox(height: 12),
              buildTextField("Supervisor", allocationSupervisorController),
              const SizedBox(height: 12),

              // From & To Date
              Row(
                children: [
                  Expanded(
                    child: buildDatePicker("From Date", fromDate, () {
                      pickDate(true);
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildDatePicker("To Date", toDate, () {
                      pickDate(false);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: status,
                  items: const [
                    DropdownMenuItem(value: "Active", child: Text("Active")),
                    DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
                  ],
                  onChanged: (value) => setState(() => status = value!),
                  buttonStyleData: const ButtonStyleData(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border:
                          Border.fromBorderSide(BorderSide(color: Colors.grey)),
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
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      saveSite();
                      widget.onBack?.call();
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
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: widget.onBack,
                    child: const Text("Cancel",
                        style: TextStyle(color: AppColor.white)),
                  ),
                ],
              ),
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

Widget buildDatePicker(String label, String? date, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primary),
        ),
      ),
      child: Text(date ?? "Select Date"),
    ),
  );
}
