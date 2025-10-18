import 'package:flutter/material.dart';
import 'model/model_employees.dart';

class DetailEmployees extends StatelessWidget {
  const DetailEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    final Datum pegawai = ModalRoute.of(context)!.settings.arguments as Datum;

    return Scaffold(
      appBar: AppBar(
        title: Text(pegawai.name),
        backgroundColor: const Color(0xFF2193b0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildDetailItem("Nama", pegawai.name),
            _buildDetailItem("Posisi", pegawai.posistion),
            _buildDetailItem("No. Telp", pegawai.phone),
            _buildDetailItem("Email", pegawai.email),
            _buildDetailItem("Alamat", pegawai.address),
            const Divider(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
