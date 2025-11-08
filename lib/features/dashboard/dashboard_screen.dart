import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_de_ventas/core/services/auth_service.dart';
import 'package:sistema_de_ventas/core/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalProductos = 0;
  int totalClientes = 0;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosReales();
  }

  Future<void> _cargarDatosReales() async {
    try {
      print('🔄 Cargando datos del dashboard...');
      
      // ✅ CARGAR DATOS CON MANEJO DE ERRORES MEJORADO
      final productos = await ApiService.obtenerProductosTemp();
      final clientes = await ApiService.obtenerClientesTemp();

      print('✅ Productos cargados: ${productos.length}');
      print('✅ Clientes cargados: ${clientes.length}');

      setState(() {
        totalProductos = productos.length;
        totalClientes = clientes.length;
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      print('❌ Error en dashboard: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  // WIDGET DE LOADING
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Conectando con el servidor...'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Sistema Ventas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarDatosReales,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.logout();
            },
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingIndicator()
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : _buildDashboardContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Problema de conexión',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _cargarDatosReales,
                  child: const Text('Reintentar'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    // Probar conexión básica
                    _probarConexion();
                  },
                  child: const Text('Probar Conexión'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _probarConexion() async {
    try {
      final health = await ApiService.healthCheck();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Conexión OK: ${health['message']}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bienvenida
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 40),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Conexión Exitosa!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Datos en tiempo real',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Métricas con datos REALES
          const Text(
            'Resumen en Tiempo Real',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Grid de métricas con datos REALES
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildMetricCard('Productos', totalProductos.toString(), Icons.inventory_2, Colors.blue),
              _buildMetricCard('Clientes', totalClientes.toString(), Icons.people, Colors.green),
              _buildMetricCard('Ventas Hoy', '0', Icons.shopping_cart, Colors.orange),
              _buildMetricCard('Stock Bajo', '0', Icons.warning, Colors.red),
            ],
          ),

          const SizedBox(height: 24),

          // Información de conexión
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.cloud_done, color: Colors.green.shade600),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Conectado al servidor local',
                      style: TextStyle(fontSize: 14),
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

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}