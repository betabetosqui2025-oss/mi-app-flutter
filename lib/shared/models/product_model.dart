class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final String codigoBarras;
  final String? imagenUrl;
  final bool activo;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.codigoBarras,
    this.imagenUrl,
    required this.activo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] is double) 
          ? json['precio'] 
          : double.tryParse(json['precio']?.toString() ?? '0') ?? 0.0,
      categoria: json['categoria'] ?? '',
      codigoBarras: json['codigoBarras'] ?? '',
      imagenUrl: json['imagenUrl'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'categoria': categoria,
      'codigoBarras': codigoBarras,
      'imagenUrl': imagenUrl,
      'activo': activo,
    };
  }

  String get precioFormateado => '\$${precio.toStringAsFixed(2)}';
}