


import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../constant/app_color.dart';
import 'employeemaster.dart';




class Editemployeescreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isEdit;
  final Employee? employee;
  final Function(Employee)? onSave;
  final Function(Employee)? onAdd;

  const Editemployeescreen({
    super.key,
    this.onBack,
    this.isEdit = false,
    this.employee,
    this.onAdd,
    this.onSave,
  });

  @override
  State<Editemployeescreen> createState() => _EditemployeescreenState();
}

class _EditemployeescreenState extends State<Editemployeescreen> {
  late TextEditingController employeeIdController;
  late TextEditingController employeeNameController;

 
  String status = "Active";
  String type = "Permanent";

  @override
  void initState() {
    super.initState();
  employeeIdController = TextEditingController(
      text: widget.employee != null
          ? 'S${widget.employee!.id.toString().padLeft(4, '0')}'
          : '',
    );
  employeeNameController = TextEditingController(text: widget.employee?.name ?? '');
  
   type = widget.employee?.type ?? 'Permanent';
    status = widget.employee?.status ?? 'Active';
    
  }

  @override
  void dispose() {
   employeeIdController.dispose();
    employeeNameController.dispose();

  
    super.dispose();
  }

  void saveEmployee() {
    if (employeeNameController.text.isEmpty 
        
      ) {
      return;
    }

    final newEmployee = Employee(
      id: widget.employee?.id ?? 0,
      name:employeeNameController.text,
  
     
      status: status, type: type,
    );

    if (widget.isEdit) {
      widget.onSave?.call(newEmployee);
    } else {
      widget.onAdd?.call(newEmployee);
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
                widget.isEdit ? "Edit Employee Master" : "Add Employee Master",
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
                    child: buildTextField("Employee ID", employeeIdController, enabled: false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildTextField("Employee Name",employeeNameController),
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
                    DropdownMenuItem(value: "Permanent", child: Text("Permanent")),
                    DropdownMenuItem(value: "Temporary", child: Text("Temporary")),
                    DropdownMenuItem(value: "Contract", child: Text("Contract")),
                  ],
                  onChanged: (value) => setState(() => type = value!),
                  buttonStyleData: const ButtonStyleData(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
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
                    DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
                  ],
                  onChanged: (value) => setState(() => status = value!),
                  buttonStyleData: const ButtonStyleData(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      saveEmployee();
                      widget.onBack?.call();
                    },
                    child: Text(widget.isEdit ? "Save" : "Add",style: TextStyle(color: AppColor.white),),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
               
                      // side: const BorderSide(color: AppColor.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: widget.onBack,
                    child: const Text("Cancel", style: TextStyle(color: AppColor.white)),
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

