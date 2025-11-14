import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../bloc/bloc/site/editsite_bloc.dart';
import '../../bloc/bloc/site/site_bloc.dart';

import '../../bloc/event/site/editsite_event.dart';
import '../../bloc/event/site/site_event.dart';

import '../../bloc/state/site/editsite_state.dart';

import '../../model/site/getallsitemodel.dart';
import '../../services/attendance_apiservice.dart';

import '../../constant/app_color.dart';
import '../../widgets/custom_dropdown.dart';

class EditSiteScreen extends StatefulWidget {
  final SiteBloc siteBloc;
  final Sitelist site;
  final VoidCallback onBack;

  const EditSiteScreen({
    super.key,
    required this.site,
    required this.onBack, required AttendanceApiService apiService, required Null Function() onSiteUpdated, required this.siteBloc, 
  });

  @override
  State<EditSiteScreen> createState() => _EditSiteScreenState();
}

class _EditSiteScreenState extends State<EditSiteScreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController cityController;

  late String status;
  late EditSiteBloc _editSiteBloc;

  @override
  void initState() {
    super.initState();

    idController = TextEditingController(text: widget.site.siteid ?? '');
    nameController = TextEditingController(text: widget.site.sitename ?? '');
    
    addressController = TextEditingController(text: widget.site.siteaddress ?? '');
    cityController = TextEditingController(text: widget.site.sitecity ?? '');
  

    String normalizedStatus = (widget.site.status ?? '').toLowerCase().trim();
    status = (normalizedStatus == "active" || normalizedStatus == "inactive")
        ? normalizedStatus[0].toUpperCase() + normalizedStatus.substring(1)
        : "Active";

    _editSiteBloc = EditSiteBloc(apiService: AttendanceApiService());
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    _editSiteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _editSiteBloc,
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
            child: BlocConsumer<EditSiteBloc, EditSiteState>(
              listener: (context, state) {
                if (state is EditSiteSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                   // ✅ Refresh supervisor list
                widget.siteBloc.add(FetchSiteEvent());
                  widget.onBack();
                } else if (state is EditSiteFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Edit Site", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.primary)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: idController,
                            decoration: const InputDecoration(labelText: "Site ID", border: OutlineInputBorder()),
                            enabled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: "Site Name", border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: addressController,
                            decoration: const InputDecoration(labelText: "Site Address", border: OutlineInputBorder()),
                           
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: cityController,
                            decoration: const InputDecoration(labelText: "Site City", border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                    
                       
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: state is EditSiteLoading
                              ? null
                              : () {
                                  _editSiteBloc.add(
                                    SubmitEditSite(
                                      id: widget.site.id ?? '0', // numeric DB ID
                                      siteId: idController.text,
                                     siteName: nameController.text,
                                      siteAddress: addressController.text, siteCity: cityController.text,
                                    
                                      status: status,
                                    ),
                                  );
                                },
                          child: state is EditSiteLoading
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
