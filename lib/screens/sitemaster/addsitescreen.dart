




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../bloc/bloc/site/addsite_bloc.dart';

import '../../bloc/bloc/site/site_bloc.dart';
import '../../bloc/event/site/addsite_event.dart';
import '../../bloc/event/site/site_event.dart';
import '../../bloc/state/site/addsite_state.dart';
import '../../bloc/state/site/site_state.dart';
import '../../model/site/getallsitemodel.dart';
import '../../services/attendance_apiservice.dart';
import '../../constant/app_color.dart';
import '../../widgets/custom_dropdown.dart';


class AddSiteScreen extends StatefulWidget {
  final AttendanceApiService apiService;
  final SiteBloc siteBloc;
  final VoidCallback? onBack;

  const AddSiteScreen({
    Key? key,
    required this.apiService,
    required this.siteBloc,
    this.onBack,
  }) : super(key: key);

  @override
  State<AddSiteScreen> createState() => _AddSiteScreenState();
}

class _AddSiteScreenState extends State<AddSiteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();


  String status = "Active";
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    widget.siteBloc.add(FetchSiteEvent());
  }

  void _setNextSiteId(List<Sitelist> site) {
    int maxId = 0;
    for (var s in site) {
      final numeric = s.siteid!.replaceAll(RegExp(r'[^0-9]'), '');
      final n = int.tryParse(numeric) ?? 0;
      if (n > maxId) maxId = n;
    }
    _idController.text = "S${(maxId + 1).toString().padLeft(3, '0')}";
  }

  void _saveSite(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _saved = true;
      context.read<AddSiteBloc>().add(
            CreateSiteEvent(
              siteId: _idController.text.trim(),
              siteName: _nameController.text.trim(),
              
              status: status, id: '', siteAddress: _addressController.text.trim(), siteCity: _cityController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.siteBloc),
        BlocProvider(create: (_) => AddSiteBloc(apiService: widget.apiService)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddSiteBloc, AddSiteState>(
            listener: (context, state) {
              if (state is AddSiteSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
  content: Text("${state.model.data?.sitename ?? 'Site'} added successfully"),
)

                );

                // ✅ Refresh site list
                widget.siteBloc.add(FetchSiteEvent());
              } else if (state is AddSiteFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
          BlocListener<SiteBloc, SiteState>(
            listener: (context, state) {
              if (state is SiteLoaded) {
                _setNextSiteId(state.site);
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
                      "Add Site",
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
                          child: _buildTextField("Site ID", _idController, enabled: false),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            "Site Name",
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
                          child: _buildTextField("Site Address", _addressController, validator: (v) => v!.isEmpty ? "Enter address" : null, ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            "Site City",
                            _cityController,
                            validator: (v) => v!.isEmpty ? "Enter city" : null,
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
                        BlocBuilder<AddSiteBloc, AddSiteState>(
                          builder: (context, state) {
                            if (state is AddSiteLoading) {
                              return const CircularProgressIndicator();
                            }
                            return ElevatedButton(
                              onPressed: () => _saveSite(context),
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
                          onPressed: widget.onBack,
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
