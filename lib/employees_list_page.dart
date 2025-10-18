import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/model_employees.dart';
import 'add_edit_employees_page.dart';
import 'detail_employees.dart';

class EmployeesListPage extends StatefulWidget {
  const EmployeesListPage({super.key});

  @override
  State<EmployeesListPage> createState() => _EmployeesListPageState();
}

class _EmployeesListPageState extends State<EmployeesListPage> {
  late Future<ModelEmployees> futureEmployees;

  @override
  void initState() {
    super.initState();
    futureEmployees = fetchEmployees();
  }

  Future<ModelEmployees> fetchEmployees() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.22:8087/getEmployees.php'),
    );

    if (response.statusCode == 200) {
      return modelEmployeesFromJson(response.body);
    } else {
      throw Exception('Gagal memuat data employees');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      futureEmployees = fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Konten
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: Color(0xFF2193b0),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Daftar Employees',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.1,
                          shadows: [
                            Shadow(blurRadius: 8, color: Colors.black26),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: FutureBuilder<ModelEmployees>(
                    future: futureEmployees,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF2193b0),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.data.isEmpty) {
                        return const Center(
                          child: Text(
                            'Data employees tidak ditemukan',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      final employeeList = snapshot.data!.data;

                      return RefreshIndicator(
                        onRefresh: _refreshData,
                        color: const Color(0xFF2193b0),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: employeeList.length,
                          itemBuilder: (context, index) {
                            final employee = employeeList[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2193b0,
                                    ).withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1.2,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF2193b0),
                                  child: Text(
                                    employee.name.isNotEmpty
                                        ? employee.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  employee.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color(0xFF2193b0),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Posisi: ${employee.posistion}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Email: ${employee.email}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Telepon: ${employee.phone}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      tooltip: 'Edit',
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => AddEditEmployeesPage(
                                                  pegawai: employee,
                                                ),
                                          ),
                                        );
                                        if (result == true) _refreshData();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Hapus',
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('Konfirmasi'),
                                                content: const Text(
                                                  'Yakin ingin menghapus employee ini?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text('Hapus'),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (confirm == true) {
                                          await deleteEmployee(employee.id);
                                          _refreshData();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DetailEmployees(),
                                      settings: RouteSettings(
                                        arguments: employee,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddEditEmployeesPage(),
                  ),
                );
                if (result == true) _refreshData();
              },
              backgroundColor: const Color(0xFF2193b0),
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Tambah Employee',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteEmployee(int id) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.22:8087/deleteEmployees.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id': id.toString()},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success' ||
            responseData['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil dihapus')),
          );
        } else {
          throw Exception(responseData['message'] ?? 'Gagal menghapus data');
        }
      } else {
        throw Exception('Gagal menghapus data: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
