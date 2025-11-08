import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_de_ventas/core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = 'admin'; // ← CAMBIADO: de 'admin@ventas.com' a 'admin'
    _passwordController.text = '123456';
  }

  Future<void> _login() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final result = await authService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    
    if (result['success'] == true) {
      // Login exitoso - la navegación se maneja automáticamente por AppContent
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    if (authService.isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo decorativo
          Positioned(
            top: -size.height * 0.15,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Positioned(
            bottom: -size.height * 0.2,
            left: -size.width * 0.1,
            child: Container(
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: Column(
                  children: [
                    // Espacio superior
                    const SizedBox(height: 40),

                    // Logo y título
                    _buildHeader(),

                    const Spacer(),

                    // Formulario
                    _buildLoginForm(),

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo container con efecto neumórfico
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(5, 5),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 20,
                offset: const Offset(-5, -5),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logos/app_logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.point_of_sale,
                    size: 40,
                    color: Colors.blue,
                  ),
                );
              },
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Título principal
        const Text(
          'Sistema de Ventas',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo
        const Text(
          'Gestión Profesional de Inventario',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del formulario
          const Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Ingresa a tu cuenta para continuar',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          
          const SizedBox(height: 32),

          // Campo Email
          _buildEmailField(),

          const SizedBox(height: 20),

          // Campo Contraseña
          _buildPasswordField(),

          const SizedBox(height: 24),

          // Botón Login
          _buildLoginButton(),

          const SizedBox(height: 24),

          // Información de demo
          _buildDemoCard(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Correo Electrónico',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _emailController,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: 'ejemplo@empresa.com',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contraseña',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: 'Ingresa tu contraseña',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.lock_outlined,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword 
                      ? Icons.visibility_outlined 
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF6B7280),
                  size: 20,
                ),
                onPressed: _togglePasswordVisibility,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isHovering
                ? [const Color(0xFF2563EB), const Color(0xFF1D4ED8)]
                : [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _login,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Acceder al Sistema',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: _isHovering ? 0.5 : 0.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(
                      _isHovering ? 4 : 0,
                      0,
                      0,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFBAE6FD),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Credenciales de Prueba',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0369A1),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF0C4A6E),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: 'Para acceder al sistema demo usa:\n\n',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: '👤 '),
                TextSpan(
                  text: 'Usuario: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: 'admin\n'), // ← CAMBIADO: de 'Correo' a 'Usuario'
                TextSpan(text: '🔐 '),
                TextSpan(
                  text: 'Contraseña: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: '123456'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animado
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logos/app_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.point_of_sale,
                        size: 32,
                        color: Color(0xFF0EA5E9),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EA5E9)),
              strokeWidth: 2,
            ),
            const SizedBox(height: 20),
            const Text(
              'Iniciando sesión...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bienvenido al Sistema de Ventas',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}