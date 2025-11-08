import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Para evitar problemas de CORS, usamos 127.0.0.1 en lugar de localhost
  static String get baseUrl {
    return 'http://127.0.0.1:8080';
  }

  static String? _token;

  // Inicializar servicio
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // Guardar token
  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Eliminar token
  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Headers con autenticación
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // ✅ POST REQUEST - AGREGADO
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      print('🔗 Haciendo POST a: $baseUrl$endpoint');
      print('📤 Datos: $data');
      
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );
      
      print('📥 Respuesta POST: ${response.statusCode}');
      print('📦 Body: ${response.body}');
      
      return response;
    } catch (e) {
      print('❌ Error en POST: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // GET request con mejor manejo de errores
  static Future<http.Response> get(String endpoint) async {
    try {
      print('🔗 Haciendo GET a: $baseUrl$endpoint');
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      
      print('📥 Respuesta: ${response.statusCode}');
      print('📦 Body: ${response.body}');
      
      return response;
    } catch (e) {
      print('❌ Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Verificar si está logueado
  static bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  // ==================== ✅ MÉTODOS TEMPORALES MEJORADOS ====================

  // HEALTH CHECK
  static Future<Map<String, dynamic>> healthCheck() async {
    final response = await get('/api/mobile/health');
    
    if (response.statusCode == 200) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw Exception('Error decodificando JSON: $e');
      }
    } else {
      throw Exception('Error en health check: ${response.statusCode}');
    }
  }

  // PRODUCTOS TEMPORAL
  static Future<List<dynamic>> obtenerProductosTemp() async {
    final response = await get('/api/mobile/products');
    
    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded;
        } else {
          throw Exception('La respuesta no es una lista: $decoded');
        }
      } catch (e) {
        print('❌ Error decodificando productos: $e');
        print('📦 Body recibido: ${response.body}');
        throw Exception('Error decodificando productos: $e');
      }
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  // CLIENTES TEMPORAL
  static Future<List<dynamic>> obtenerClientesTemp() async {
    final response = await get('/api/mobile/clients');
    
    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded;
        } else {
          throw Exception('La respuesta no es una lista: $decoded');
        }
      } catch (e) {
        print('❌ Error decodificando clientes: $e');
        print('📦 Body recibido: ${response.body}');
        throw Exception('Error decodificando clientes: $e');
      }
    } else {
      throw Exception('Error al cargar clientes: ${response.statusCode}');
    }
  }
}