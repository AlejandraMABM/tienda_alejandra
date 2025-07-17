import 'package:uuid/uuid.dart';
import '../models/producto.dart';
import '../utils/csv_manager.dart';

class ProductoService {
  late CsvManager _csv;
  final List<Producto> _prods = [];
  final Uuid _uuid = const Uuid();

  void initWithPath(String path) => _csv = CsvManager(path);

  Future<void> cargarProductos() async {
    final data = await _csv.readProducts();
    _prods
      ..clear()
      ..addAll(data.map((m) => Producto.fromMap(m)));
  }

  Future<void> guardarProductos() async {
    final data = _prods.map((p) => p.toMap()).toList();
    await _csv.writeProducts(data);
  }

  void addProducto(Producto p) {
    if (p.id.isEmpty) p.id = _uuid.v4();
    _prods.add(p);
  }

  bool updateProducto(Producto p) {
    final i = _prods.indexWhere((x) => x.id == p.id);
    if (i < 0) return false;
    _prods[i] = p;
    return true;
  }

  bool deleteProducto(String id) {
    final count = _prods.length;
    _prods.removeWhere((x) => x.id == id);
    return _prods.length < count;
  }

  List<Producto> getAllProductos() => List.unmodifiable(_prods);

  List<Producto> getProductosUnicos() {
    final seen = <String>{};
    return _prods.where((p) => seen.add('${p.nombre}-${p.categoria}')).toList();
  }

  double getValorTotalInventario() =>
      _prods.fold(0.0, (sum, p) => sum + p.precio * p.cantidad);

  Map<String, List<Producto>> getProductosPorCategoria() {
    final m = <String, List<Producto>>{};
    for (var p in _prods) {
      m.putIfAbsent(p.categoria, () => []).add(p);
    }
    return m;
  }

  List<Producto> getProductosBajoStock(int umbral) =>
      _prods.where((p) => p.cantidad < umbral).toList();
}
