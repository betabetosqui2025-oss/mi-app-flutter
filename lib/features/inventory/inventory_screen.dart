import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warehouse, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Control de Inventario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Aquí se gestionará el inventario',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}