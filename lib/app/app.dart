import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:sistema_de_ventas/core/services/auth_service.dart';
import 'package:sistema_de_ventas/features/auth/login_screen.dart';  
import 'package:sistema_de_ventas/features/dashboard/dashboard_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Sistema de Ventas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AppContent(),
      ),
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);  
    
    return authService.isAuthenticated
        ? const DashboardScreen()
        : const LoginScreen();
  }
}