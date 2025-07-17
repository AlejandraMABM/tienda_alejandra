import 'package:uuid/uuid.dart';
import '../models/producto.dart';
import '../utils/csv_manager.dart';

class ProductoService {
  late CsvManager _csv;
  final List<Producto> _prods = [];
  final Uuid _uuid = const Uuid();

  /// Inicializa el gestor CSV con la ruta proporcionada
  void initWithPath(String path) {
    _csv = CsvManager(path);
  }

  /// Carga los productos desde el archivo CSV
  Future<void> cargarProductos() async {
    try {
      final data = await _csv.readProducts();
      _prods
        ..clear()
        ..addAll(data.map((m) => Producto.fromMap(m)));
    } catch (e) {
      print('Error cargando productos: $e');
    }
  }

  /// Guarda los productos actuales en el archivo CSV
  Future<void> guardarProductos() async {
    try {
      final data = _prods.map((p) => p.toMap()).toList();
      await _csv.writeProducts(data);
    } catch (e) {
      print('Error guardando productos: $e');
    }
  }

  /// Agrega un nuevo producto con ID generado si es necesario
  void addProducto(Producto p) {
    if (p.id.trim().isEmpty) {
      p.id = _uuid.v4();
    }
    _prods.add(p);
  }

  /// Actualiza un producto existente por ID
  bool updateProducto(Producto p) {
    final i = _prods.indexWhere((x) => x.id == p.id);
    if (i < 0) return false;
    _prods[i] = p;
    return true;
  }

  /// Elimina un producto por ID
  bool deleteProducto(String id) {
    final inicial = _prods.length;
    _prods.removeWhere((x) => x.id == id);
    return _prods.length < inicial;
  }

  /// Devuelve una lista de productos (copia no modificable)
  List<Producto> getAllProductos() => List.unmodifiable(_prods);

  /// Devuelve productos únicos (por nombre y categoría)
  List<Producto> getProductosUnicos() {
    final vistos = <String>{};
    return _prods.where((p) => vistos.add('${p.nombre}-${p.categoria}')).toList();
  }

  /// Calcula el valor total del inventario (precio * cantidad)
  double getValorTotalInventario() {
    return _prods.fold(0.0, (sum, p) => sum + (p.precio * p.cantidad));
  }

  /// Devuelve los productos agrupados por categoría
  Map<String, List<Producto>> getProductosPorCategoria() {
    final mapa = <String, List<Producto>>{};
    for (var p in _prods) {
      mapa.putIfAbsent(p.categoria, () => []).add(p);
    }
    return mapa;
  }

  /// Devuelve productos con cantidad menor al umbral
  List<Producto> getProductosBajoStock(int umbral) {
    return _prods.where((p) => p.cantidad < umbral).toList();
  }
}

