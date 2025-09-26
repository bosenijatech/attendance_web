


import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../constant/app_color.dart';
import 'sitemasterscreen.dart';

class Editsitemasterscreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isEdit;
  final Site? site;
  final Function(Site)? onSave;
  final Function(Site)? onAdd;

  const Editsitemasterscreen({
    super.key,
    this.onBack,
    this.isEdit = false,
    this.site,
    this.onAdd,
    this.onSave,
  });

  @override
  State<Editsitemasterscreen> createState() => _EditsitemasterscreenState();
}

class _EditsitemasterscreenState extends State<Editsitemasterscreen> {
  late TextEditingController siteIdController;
  late TextEditingController siteNameController;
  late TextEditingController siteAddressController;
  late TextEditingController cityController;
  String status = "Active";

  @override
  void initState() {
    super.initState();
    siteIdController = TextEditingController(
      text: widget.site != null
          ? 'S${widget.site!.id.toString().padLeft(4, '0')}'
          : '',
    );
    siteNameController = TextEditingController(text: widget.site?.name ?? '');
    siteAddressController = TextEditingController(text: widget.site?.address ?? '');
    cityController = TextEditingController(text: widget.site?.city ?? '');
    status = widget.site?.status ?? 'Active';
  }

  @override
  void dispose() {
    siteIdController.dispose();
    siteNameController.dispose();
    siteAddressController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void saveSite() {
    if (siteNameController.text.isEmpty ||
        siteAddressController.text.isEmpty ||
        cityController.text.isEmpty) {
      return;
    }

    final newSite = Site(
      id: widget.site?.id ?? 0,
      name: siteNameController.text,
      address: siteAddressController.text,
      city: cityController.text,
      status: status,
    );

    if (widget.isEdit) {
      widget.onSave?.call(newSite);
    } else {
      widget.onAdd?.call(newSite);
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
                widget.isEdit ? "Edit Site Master" : "Add Site Master",
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
                    child: buildTextField("Site ID", siteIdController, enabled: false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildTextField("Site Name", siteNameController),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: buildTextField("Site Address", siteAddressController)),
                  const SizedBox(width: 12),
                  Expanded(child: buildTextField("City", cityController)),
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
                      saveSite();
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

