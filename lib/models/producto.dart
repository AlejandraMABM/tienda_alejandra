class Producto {
  String id;
  final String nombre;
  final double precio;
  final int cantidad;
  final String categoria;

  Producto({
    this.id = '',
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.categoria,
  });
 

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      precio: (map['precio'] is String)
          ? double.parse(map['precio'])
          : (map['precio'] ?? 0.0),
      cantidad: (map['cantidad'] is String)
          ? int.parse(map['cantidad'])
          : (map['cantidad'] ?? 0),
      categoria: map['categoria'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio.toString(),
      'cantidad': cantidad.toString(),
      'categoria': categoria.toString(),
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
