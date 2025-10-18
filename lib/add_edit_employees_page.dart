import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/model_employees.dart';

class AddEditEmployeesPage extends StatefulWidget {
  final Datum? pegawai;
  const AddEditEmployeesPage({Key? key, this.pegawai}) : super(key: key);

  @override
  State<AddEditEmployeesPage> createState() => _AddEditEmployeesPageState();
}

class _AddEditEmployeesPageState extends State<AddEditEmployeesPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController posistionController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.pegawai?.name ?? '');
    posistionController = TextEditingController(
      text: widget.pegawai?.posistion ?? '',
    );
    phoneController = TextEditingController(text: widget.pegawai?.phone ?? '');
    emailController = TextEditingController(text: widget.pegawai?.email ?? '');
    addressController = TextEditingController(
      text: widget.pegawai?.address ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    posistionController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> submitPegawai() async {
    if (_formKey.currentState!.validate()) {
      try {
        final isEdit = widget.pegawai != null;
        final baseUrl = 'http://192.168.1.22:8087';
        final endpoint = isEdit ? '/editEmployees.php' : '/addEmployees.php';

        print('Submitting to: ${baseUrl + endpoint}');

        final Map<String, dynamic> requestData = {
          if (isEdit) 'id': widget.pegawai!.id.toString(),
          'name': nameController.text,
          'posistion': posistionController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
        };

        print('Request body: $requestData');

        final response = await http.post(
          Uri.parse(baseUrl + endpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestData),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['status'] == 'success' ||
              responseData['isSuccess'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEdit
                      ? 'Data berhasil diupdate'
                      : 'Data berhasil ditambahkan',
                ),
              ),
            );
            Navigator.pop(context, true);
          } else {
            throw Exception(responseData['message'] ?? 'Gagal menyimpan data');
          }
        } else {
          throw Exception('Gagal menyimpan data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder:
                        (context, scale, child) => Transform.scale(
                          scale: scale,
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white,
                            child: Icon(
                              widget.pegawai == null
                                  ? Icons.person_add
                                  : Icons.edit,
                              size: 52,
                              color: Color.fromARGB(255, 193, 236, 247),
                            ),
                          ),
                        ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.pegawai == null ? 'Tambah Pegawai' : 'Edit Pegawai',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 193, 236, 247),
                      letterSpacing: 1.2,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black12)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pegawai == null
                        ? 'Isi data pegawai baru'
                        : 'Edit data pegawai',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(28),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2193b0).withOpacity(0.2),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: Colors.white24, width: 1.2),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildInput(
                            controller: nameController,
                            label: 'Nama',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 16),
                          _buildInput(
                            controller: posistionController,
                            label: 'Posisi',
                            icon: Icons.work,
                          ),
                          const SizedBox(height: 16),
                          _buildInput(
                            controller: phoneController,
                            label: 'No. Telp',
                            icon: Icons.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildInput(
                            controller: emailController,
                            label: 'Email',
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 16),
                          _buildInput(
                            controller: addressController,
                            label: 'Alamat',
                            icon: Icons.home,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color(0xFF2193b0),
                              ),
                              onPressed: submitPegawai,
                              child: Text(
                                widget.pegawai == null ? 'Tambah' : 'Simpan',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Color.fromARGB(255, 193, 236, 247)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 193, 236, 247)),
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 193, 236, 247)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 193, 236, 247),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 193, 236, 247),
            width: 2,
          ),
        ),
      ),
      validator: (value) => value!.isEmpty ? '$label wajib diisi' : null,
    );
  }
}
