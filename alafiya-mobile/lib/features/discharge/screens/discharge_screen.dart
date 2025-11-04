import 'package:flutter/material.dart';

class DischargeScreen extends StatelessWidget {
  const DischargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discharge'),
      ),
      body: const Center(
        child: Text('Discharge Management Screen'),
      ),
    );
  }
}