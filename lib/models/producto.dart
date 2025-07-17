class Producto {
  String id;
  final String nombre;
  final double precio;
  final int cantidad;
  final String categoria;
  final String? imagenUrl;

  Producto({
    this.id = '',
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.categoria,
    required this.imagenUrl,
  });

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      precio: double.tryParse(map['precio'].toString()) ?? 0.0,
      cantidad: int.tryParse(map['cantidad'].toString()) ?? 0,
      categoria: map['categoria'] ?? 'Otros',
      imagenUrl: (map['imagenUrl']?.toString().trim().isNotEmpty ?? false)
          ? map['imagenUrl'].toString()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'categoria': categoria,
      'imagenUrl': imagenUrl ?? '',
    };
  }

  static const List<String> categoriasDisponibles = [
    'Juguetes',
    'Tecnología',
    'Libros',
    'Ropa',
    'Otros',
  ];
}

