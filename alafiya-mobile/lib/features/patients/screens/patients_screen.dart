import 'package:flutter/material.dart';

/// Patients Screen
class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
      ),
      body: const Center(
        child: Text('Patients Management Screen'),
      ),
    );
  }
}