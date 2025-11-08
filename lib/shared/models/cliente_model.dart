class Cliente {
  final String id;
  final String nombre;
  final String apellido;
  final String numeroDocumento;
  final String tipoDocumento;
  final String email;
  final String telefono;
  final String direccion;
  final String ciudad;
  final String pais;
  final String notas;

  Cliente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.numeroDocumento,
    required this.tipoDocumento,
    required this.email,
    required this.telefono,
    required this.direccion,
    required this.ciudad,
    required this.pais,
    required this.notas,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      numeroDocumento: json['numeroDocumento'] ?? '',
      tipoDocumento: json['tipoDocumento'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      direccion: json['direccion'] ?? '',
      ciudad: json['ciudad'] ?? '',
      pais: json['pais'] ?? '',
      notas: json['notas'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'numeroDocumento': numeroDocumento,
      'tipoDocumento': tipoDocumento,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'ciudad': ciudad,
      'pais': pais,
      'notas': notas,
    };
  }

  String get nombreCompleto => '$nombre $apellido'.trim();
}