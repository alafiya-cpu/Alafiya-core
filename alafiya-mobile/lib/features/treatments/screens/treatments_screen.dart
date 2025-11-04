import 'package:flutter/material.dart';

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatments'),
      ),
      body: const Center(
        child: Text('Treatments Screen'),
      ),
    );
  }
}