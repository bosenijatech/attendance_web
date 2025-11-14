

import 'package:attendance_web/authscreen/landingpage.dart';
import 'package:attendance_web/bloc/bloc/allocation/allocation_bloc.dart';
import 'package:attendance_web/bloc/bloc/employee/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../bloc/bloc/allocation/deleteallocation_bloc.dart';
import '../bloc/bloc/employee/deleteemployee_bloc.dart';
import '../bloc/bloc/projectmaster/deleteproject_bloc.dart';
import '../bloc/bloc/projectmaster/project_bloc.dart';
import '../bloc/bloc/site/deletesite_bloc.dart';
import '../bloc/bloc/site/site_bloc.dart';
import '../bloc/bloc/supervisor/deletesupervisor_bloc.dart';
import '../bloc/bloc/supervisor/supervisor_bloc.dart';


import '../bloc/event/allocation/allocation_event.dart';
import '../bloc/event/employee/employee_event.dart';
import '../bloc/event/projectmaster/project_event.dart';
import '../bloc/event/site/site_event.dart';
import '../bloc/event/supervisor/supervisor_event.dart';
import '../bloc/state/allocation/allocation_state.dart';
import '../bloc/state/employee/employee_state.dart';
import '../bloc/state/projectmaster/project_state.dart';
import '../bloc/state/site/site_state.dart';
import '../bloc/state/supervisor/supervisor_state.dart';
import '../model/supervisor/getallsupervisormodel.dart';
import '../services/attendance_apiservice.dart';
import 'dashboard/dashboardscreen.dart';
import 'employeemaster/addemployeescreen.dart';
import 'employeemaster/editemployeescreen.dart';
import 'employeemaster/employeemaster.dart';
import 'projectallocation/addallocationscreen.dart';
import 'projectallocation/allocationmaster.dart';
import 'projectallocation/editallocationscreen.dart';
import 'projectmaster/addprojectmasterscreen.dart';
import 'projectmaster/editprojectmasterscreen.dart';
import 'projectmaster/projectmasterscreen.dart';
import 'sitemaster/addsitescreen.dart';
import 'sitemaster/editsitescreen.dart';
import 'sitemaster/sitemasterscreen.dart';
import 'supervisormaster/addsupervisorscreen.dart';
import 'supervisormaster/editsupervisorscreen.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_color.dart';
import 'supervisormaster/supervisormaster.dart';

class AdminScreen extends StatefulWidget {
  final int notificationCount;
  const AdminScreen({super.key, this.notificationCount = 0});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int selectedIndex = 0;
  int hoveredIndex = -1;

  final List<String> menuItems = [
    "Dashboard",
    "Site Master",
    "Project Master",
    "Supervisor Master",
    "Employee Master",
    "Project Allocation",
  ];

  final List<String> menuIcons = [
    AppAssets.dashboard,
    AppAssets.sitemaster,
    AppAssets.project,
    AppAssets.supervisor,
    AppAssets.employee,
    AppAssets.allocation,
  ];

  late final SupervisorBloc supervisorBloc;
  late final SiteBloc siteBloc;
  late final ProjectBloc projectBloc;
  late final EmployeeBloc employeeBloc;
  late final AllocationBloc allocationBloc;

  @override
  void initState() {
    super.initState();
    supervisorBloc = SupervisorBloc(AttendanceApiService());
    siteBloc = SiteBloc(AttendanceApiService());
    projectBloc = ProjectBloc(AttendanceApiService());
    employeeBloc = EmployeeBloc(AttendanceApiService());
    allocationBloc = AllocationBloc(AttendanceApiService());

    // Call API immediately if Supervisor tab is default
      if (selectedIndex == 1) {
      siteBloc.add(FetchSiteEvent());
    }
      if (selectedIndex == 2) {
      projectBloc.add(FetchProjectEvent());
    }
    if (selectedIndex == 3) {
      supervisorBloc.add(FetchSupervisorsEvent());
    }
    if (selectedIndex == 4) {
      employeeBloc.add(FetchEmployeeEvent());
    }
    if (selectedIndex == 5) {
      allocationBloc.add(FetchAllocationEvent());
    }
  }

  @override
  void dispose() {
    supervisorBloc.close();
    siteBloc.close();
    projectBloc.close();
    employeeBloc.close();
    allocationBloc.close();
    super.dispose();
  }

  void _onMenuTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Only fetch supervisors once when tab is selected
     if (index == 1) {
      siteBloc.add(FetchSiteEvent());
    }
         if (selectedIndex == 2) {
      projectBloc.add(FetchProjectEvent());
    }
    if (index == 3) {
      supervisorBloc.add(FetchSupervisorsEvent());
    }
    if (selectedIndex == 4) {
      employeeBloc.add(FetchEmployeeEvent());
    }
     if (selectedIndex == 5) {
      allocationBloc.add(FetchAllocationEvent());
    }
  }

//logout


  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear stored user/session data

    // navigate to login screen & remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LandingPage()),
      (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: AppColor.white,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(AppAssets.logo, scale: 12),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedIndex == index;
                      bool isHovered = hoveredIndex == index;
                  
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: MouseRegion(
                             cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => hoveredIndex = index),
                          onExit: (_) => setState(() => hoveredIndex = -1),
                       
                          child: MouseRegion(
                             cursor: SystemMouseCursors.click,
                            child: InkWell(
                              onTap: () => _onMenuTap(index),
                              borderRadius: BorderRadius.circular(8),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColor.primary
                                        : isHovered
                                            ? Colors.blueGrey.shade100
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                    child: ListTile(
                                      leading: MouseRegion(
                                                 cursor: SystemMouseCursors.click,
                                        child: SvgPicture.asset(
                                          menuIcons[index],
                                          color: isSelected ? Colors.white : AppColor.bluishGrey,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      title: MouseRegion(
                                         cursor: SystemMouseCursors.click,
                                        child: Text(
                                          menuItems[index],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : AppColor.bluishGrey,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      
                      Text(
                        menuItems[selectedIndex],
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [

                              MouseRegion(
                                         cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                   onTap: () => _logout(context),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                    Icons.logout,
                                    color: AppColor.red,
                                    size: 20,
                                  ),
                                    ),
                                  ),
                                ),
                              ),

                             const SizedBox(width: 20),
                          // Stack(
                          //   clipBehavior: Clip.none,
                          //   children: [
                          //     Container(
                          //       width: 40,
                          //       height: 40,
                          //       decoration: BoxDecoration(
                          //         color: AppColor.white,
                          //         borderRadius: BorderRadius.circular(12),
                          //       ),
                          //       child: Center(
                          //         child: SvgPicture.asset(
                          //           AppAssets.bell,
                          //           color: AppColor.navyBlue,
                          //           width: 18,
                          //           height: 18,
                          //         ),
                          //       ),
                          //     ),
                          //     if (widget.notificationCount > 0)
                          //       Positioned(
                          //         top: -5,
                          //         right: -5,
                          //         child: Container(
                          //           padding: const EdgeInsets.all(6),
                          //           decoration: BoxDecoration(
                          //             color: Colors.red,
                          //             shape: BoxShape.circle,
                          //             border: Border.all(
                          //               color: Colors.white,
                          //               width: 2,
                          //             ),
                          //           ),
                          //           child: Text(
                          //             widget.notificationCount.toString(),
                          //             style: const TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 12,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //   ],
                          // ),
                          // const SizedBox(width: 20),
                          MouseRegion(
                                     cursor: SystemMouseCursors.click,
                            child: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            

                // Dynamic Page Content
                Expanded(
                  child: Builder(builder: (context) {
                    switch (selectedIndex) {
                      case 0:
                        return const DashboardScreen();


                        
                      case 1:
                        // Site Master
                        return 
                       MultiBlocProvider(
    providers: [
      BlocProvider.value(value: siteBloc),
      BlocProvider(
        create: (context) => DeleteSiteBloc(apiService: AttendanceApiService()),
      ),
    ],
                          child: BlocBuilder<SiteBloc, SiteState>(
                            builder: (context, state) {
                              if (state is SiteLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is SiteLoaded) {
                                return Sitemasterscreen(
                                  site: state.site,
                                  onAdd: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddSiteScreen(
                                          apiService: AttendanceApiService(),
                                          siteBloc: siteBloc,
                                          onBack: () => Navigator.pop(context),
                                        ),
                                      ),
                                    );
                                  },
                                  onEdit: (site) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditSiteScreen(
                                          apiService: AttendanceApiService(),
                                          site: site,
                                          onBack: () => Navigator.pop(context), onSiteUpdated: () {  }, siteBloc: siteBloc,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is SiteError) {
                                return Center(
                                    child: Text("Error: ${state.message}"));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        );

                        
                      case 2:
                        // Project Master
                        return
                        MultiBlocProvider(
    providers: [
      BlocProvider.value(value: projectBloc),
      BlocProvider(
        create: (context) => DeleteProjectBloc(apiService: AttendanceApiService()),
      ),
    ],
                          child: BlocBuilder<ProjectBloc, ProjectState>(
                            builder: (context, state) {
                              if (state is ProjectLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is ProjectLoaded) {
                                return ProjectmasterScreen(
                                  project: state.project,
                                  onAdd: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Addprojectmasterscreen(
                                          apiService: AttendanceApiService(),
                                          projectBloc: projectBloc,
                                          onBack: () => Navigator.pop(context),
                                        ),
                                      ),
                                    );
                                  },
                                  onEdit: (project) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Editprojectmasterscreen(
                                          apiService: AttendanceApiService(),
                                          project: project,
                                          onBack: () => Navigator.pop(context), onProjectUpdated: () {  }, projectBloc: projectBloc,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is ProjectError) {
                                return Center(
                                    child: Text("Error: ${state.message}"));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        );


                        
                      case 3:
                      
                 
  // Supervisor Master
  return
   MultiBlocProvider(
    providers: [
      BlocProvider.value(value: supervisorBloc),
      BlocProvider(
        create: (context) => DeleteSupervisorBloc(apiService: AttendanceApiService()),
      ),
    ],
    child: BlocBuilder<SupervisorBloc, SupervisorState>(
      builder: (context, state) {
        if (state is SupervisorLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SupervisorLoaded) {
          return SupervisormasterScreen(
            supervisors: state.supervisors,
            onAdd: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddSupervisorScreen(
                    apiService: AttendanceApiService(),
                    supervisorBloc: supervisorBloc,
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
            },
            onEdit: (supervisor) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditSupervisorScreen(
                    apiService: AttendanceApiService(),
                    supervisor: supervisor,
                    onBack: () => Navigator.pop(context),
                    onSupervisorUpdated: () {},
                    supervisorBloc: supervisorBloc,
                  ),
                ),
              );
            },
          );
        } else if (state is SupervisorError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const SizedBox.shrink();
      },
    ),
  );

                        
                      case 4:
                        // Employee Master
                        return 
                          MultiBlocProvider(
    providers: [
      BlocProvider.value(value: employeeBloc),
      BlocProvider(
        create: (context) => DeleteEmployeeBloc(apiService: AttendanceApiService()),
      ),
    ],
                          child: BlocBuilder<EmployeeBloc, EmployeeState>(
                            builder: (context, state) {
                              if (state is EmployeeLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is EmployeeLoaded) {
                                return EmployeemasterScreen(
                                  employee: state.employee,
                                  onAdd: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddemployeeScreen(
                                          apiService: AttendanceApiService(),
                                          employeeBloc: employeeBloc,
                                          onBack: () => Navigator.pop(context),
                                        ),
                                      ),
                                    );
                                  },
                                  onEdit: (employee) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Editemployeescreen(
                                          apiService: AttendanceApiService(),
                                          employee: employee,
                                          onBack: () => Navigator.pop(context), onEmployeeUpdated: () {  }, employeeBloc: employeeBloc,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is EmployeeError) {
                                return Center(
                                    child: Text("Error: ${state.message}"));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        );
                      case 5:
                        // Allocation Master
                        return 
                       

            
                          MultiBlocProvider(
    providers: [
      BlocProvider.value(value: allocationBloc),
      BlocProvider(
        create: (context) => DeleteAllocationBloc(apiService: AttendanceApiService()),
      ),
    ],
                          child: BlocBuilder<AllocationBloc, AllocationState>(
                            builder: (context, state) {
                              if (state is AllocationLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is AllocationLoaded) {
                                return AllocationmasterScreen(
                                  allocation: state.allocation,
                                  onAdd: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddAllocationScreen(
                                          apiService: AttendanceApiService(),
                                          allocationBloc: allocationBloc,
                                          onBack: () => Navigator.pop(context),
                                        ),
                                      ),
                                    );
                                  },
                                  onEdit: (allocation) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditAllocationScreen(
                                          apiService: AttendanceApiService(),
                                            allocation:   allocation,
                                          onBack: () => Navigator.pop(context), onAllocationUpdated: () {  }, allocationBloc: allocationBloc,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is AllocationError) {
                                return Center(
                                    child: Text("Error: ${state.message}"));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        );
                      default:
                        return const Center(child: Text("Coming Soon"));
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




