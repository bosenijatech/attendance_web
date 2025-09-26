

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constant/app_color.dart';
import '../../constant/app_assets.dart';
import 'editsitemasterscreen.dart';

class Sitemasterscreen extends StatefulWidget {
  const Sitemasterscreen({super.key, required void Function() onAdd, required void Function() onEdit});

  @override
  State<Sitemasterscreen> createState() => _SitemasterscreenState();
}

class _SitemasterscreenState extends State<Sitemasterscreen> {
  String currentView = "list"; // "list" | "add" | "edit"
  Site? selectedSite;

  List<Site> sites = List.generate(
    53,
    (index) => Site(
      id: index + 1,
      name: 'Site ${index + 1}',
      address: 'Address ${index + 1}',
      city: 'City ${index % 10 + 1}',
      status: (index % 2 == 0) ? 'Active' : 'Inactive',
    ),
  );

  int currentPage = 1;
  final int sitesPerPage = 7;

  List<int> getVisiblePages(int totalPages) {
    List<int> pages = [];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) pages.add(i);
    } else {
      if (currentPage <= 3) {
        pages.addAll([1, 2, 3, -1, totalPages]);
      } else if (currentPage >= totalPages - 2) {
        pages.addAll([1, -1, totalPages - 2, totalPages - 1, totalPages]);
      } else {
        pages.addAll([1, -1, currentPage - 1, currentPage, currentPage + 1, -1, totalPages]);
      }
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    // ===== If Add Page =====
    if (currentView == "add") {
      return Editsitemasterscreen(
        isEdit: false,
        onBack: () => setState(() => currentView = "list"),
        onAdd: (newSite) {
          setState(() {
            newSite.id = sites.length + 1;
            sites.add(newSite);
            currentView = "list";
          });
        }, onSave: (updatedSite) {  },
      );
    }

    // ===== If Edit Page =====
    if (currentView == "edit" && selectedSite != null) {
      return Editsitemasterscreen(
        isEdit: true,
        site: selectedSite,
        onBack: () => setState(() {
          currentView = "list";
          selectedSite = null;
        }),
        onSave: (updatedSite) {
          setState(() {
            int index = sites.indexWhere((s) => s.id == updatedSite.id);
            if (index != -1) sites[index] = updatedSite;
            currentView = "list";
          });
        }, onAdd: (newSite) {  },
      );
    }

    // ===== Default Site List Page (Your Design) =====
    int totalPages = (sites.length / sitesPerPage).ceil();
    int start = (currentPage - 1) * sitesPerPage;
    int end = (start + sitesPerPage > sites.length) ? sites.length : start + sitesPerPage;
    List<Site> currentSites = sites.sublist(start, end);

    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            // ===== Search + Filter + Add =====
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              AppAssets.search,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.filter_list, color: Colors.black, size: 24),
                        SizedBox(width: 4),
                        Text('Filter', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      setState(() => currentView = "add");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add, color: Colors.white, size: 24),
                        SizedBox(width: 4),
                        Text('Add Site Master', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ===== Data Table =====
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                   
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(AppColor.primaryLight),
                          columnSpacing: 120,
                          columns: const [
                            DataColumn(label: Text('Site ID', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Site Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Site Address', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('City', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: currentSites.map((site) {
                            return DataRow(
                              cells: [
                                DataCell(Text('S${site.id.toString().padLeft(4, '0')}')),
                                DataCell(Text(site.name)),
                                DataCell(Text(site.address)),
                                DataCell(Text(site.city)),
                                DataCell(Text(
                                  site.status,
                                  style: TextStyle(
                                    color: site.status == 'Active' ? Colors.green[800] : Colors.red[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedSite = site;
                                        currentView = "edit";
                                      });
                                    },
                                    child: Image.asset(
                                      AppAssets.edit_icon,
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ===== Pagination =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: currentPage > 1 ? () => setState(() => currentPage--) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: currentPage > 1 ? AppColor.primary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MouseRegion(
                      cursor:  SystemMouseCursors.click,
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: currentPage > 1 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: getVisiblePages(totalPages).map((page) {
                    if (page == -1) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text('...', style: TextStyle(fontSize: 14)),
                      );
                    }
                    return MouseRegion(
                               cursor:  SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => setState(() => currentPage = page),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: page == currentPage ? AppColor.primary : Colors.grey[300],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              '$page',
                              style: TextStyle(
                                color: page == currentPage ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                MouseRegion(
                    cursor:  SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: currentPage < totalPages ? AppColor.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: currentPage < totalPages ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ===== Site Model =====
class Site {
  int id;
  String name;
  String address;
  String city;
  String status;

  Site({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.status,
  });
}
