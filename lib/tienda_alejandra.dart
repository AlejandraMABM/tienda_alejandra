import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tienda_alejandra/menu_principal.dart';
import 'models/producto.dart';
import 'services/producto_service.dart';

final productoService = ProductoService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  productoService.initWithPath('${dir.path}/productos.csv');
  await productoService.cargarProductos();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(context) => MaterialApp(
        title: 'Gestión Productos',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ProductoListPage(),
      );
}

class ProductoListPage extends StatefulWidget {
  const ProductoListPage({super.key});
  @override
  State<ProductoListPage> createState() => _ProductoListPageState();
}

class _ProductoListPageState extends State<ProductoListPage> {
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
    productos = productoService.getAllProductos();
  }

  Future<void> _refresh() async {
    await productoService.cargarProductos();
    setState(() => productos = productoService.getAllProductos());
  }

  void _openForm([Producto? p]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductoFormPage(producto: p)),
    );
    if (result == true) await _refresh();
  }

  void _confirmDelete(Producto p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('¿Eliminar "${p.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );
    if (ok == true) {
      productoService.deleteProducto(p.id);
      await productoService.guardarProductos();
      await _refresh();
    }
  }

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          title: const Text('Productos de Colección'),
          actions: [
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InventarioPage()),
              ),
            ),
            IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
          ],
        ),
        body: productos.isEmpty
            ? const Center(
                child: Text('No hay productos'),
              )
            : ListView.builder(
                itemCount: productos.length,
                itemBuilder: (_, i) {
                  final p = productos[i];
                  return ListTile(
                    leading: (p.imagenUrl != null && p.imagenUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              p.imagenUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                          )
                        : const Icon(Icons.image_not_supported, size: 40),
                    title: Text(p.nombre),
                    subtitle: Text(
                      'Precio: \$${p.precio.toStringAsFixed(2)} • Cant.: ${p.cantidad} • Cat: ${p.categoria}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _openForm(p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(p),
                        ),
                      ],
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openForm(),
          child: const Icon(Icons.add),
        ),
      );
}

class ProductoFormPage extends StatefulWidget {
  final Producto? producto;
  const ProductoFormPage({super.key, this.producto});
  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _n, _p, _c, _img;
  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _n = TextEditingController(text: widget.producto?.nombre ?? '');
    _p = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    _c = TextEditingController(text: widget.producto?.cantidad.toString() ?? '');
    _img = TextEditingController(text: widget.producto?.imagenUrl ?? '');
    _categoriaSeleccionada =
        widget.producto?.categoria ?? Producto.categoriasDisponibles.first;
  }

  @override
  void dispose() {
    _n.dispose();
    _p.dispose();
    _c.dispose();
    _img.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final imagen = _img.text.trim();
    final prod = Producto(
      id: widget.producto?.id ?? '',
      nombre: _n.text.trim(),
      precio: double.parse(_p.text),
      cantidad: int.parse(_c.text),
      categoria: (_categoriaSeleccionada == null || _categoriaSeleccionada!.trim().isEmpty)
          ? 'Otros'
          : _categoriaSeleccionada!.trim(),
      imagenUrl: imagen.isEmpty ? null : imagen,
    );

    if (widget.producto == null) {
      productoService.addProducto(prod);
    } else {
      productoService.updateProducto(prod);
    }
    await productoService.guardarProductos();
    if (mounted) Navigator.pop(context, true);
  }

  void _cancel() {
    Navigator.pop(context, false);
  }

  @override
  Widget build(context) {
    final edit = widget.producto != null;
    return Scaffold(
      appBar: AppBar(title: Text(edit ? 'Editar Producto' : 'Nuevo Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _n,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Campo Obligatorio' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _p,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    double.tryParse(v!) == null || double.parse(v) <= 0
                        ? 'Dato Inválido'
                        : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _c,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v!) == null || int.parse(v) < 0
                    ? 'Dato Inválido'
                    : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: Producto.categoriasDisponibles.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _categoriaSeleccionada = valor;
                  });
                },
                validator: (val) =>
                    val == null || val.isEmpty ? 'Seleccione una categoría' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _img,
                decoration: const InputDecoration(
                  labelText: 'URL de Imagen',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final val = v!.trim();
                  if (val.isEmpty) return null;
                  final uri = Uri.tryParse(val);
                  if (uri == null || !(uri.isScheme("http") || uri.isScheme("https"))) {
                    return 'URL inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(edit ? 'Guardar' : 'Crear'),
                  ),
                  ElevatedButton(
                    onPressed: _cancel,
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  @override
  Widget build(context) {
    final uniques = productoService.getProductosUnicos();
    final total = productoService.getValorTotalInventario();
    final byCat = productoService.getProductosPorCategoria();
    final low = productoService.getProductosBajoStock(10);

    return Scaffold(
      appBar: AppBar(title: const Text('Informe de Inventario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Productos únicos:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (uniques.isEmpty)
              const Text('Ninguno')
            else
              ...uniques.map((p) => Text('• ${p.nombre} (${p.categoria})')),
            const SizedBox(height: 16),
            Text(
              'Valor total del inventario: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Por categoría:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (byCat.isEmpty)
              const Text('Nada')
            else
              ...byCat.entries.expand(
                (e) => [
                  Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ...e.value.map(
                    (p) => Text('  • ${p.nombre} (Cant: ${p.cantidad})'),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Text('Stock bajo (<10):', style: TextStyle(fontWeight: FontWeight.bold)),
            if (low.isEmpty)
              const Text('Nada')
            else
              ...low.map((p) => Text('• ${p.nombre} (Cant: ${p.cantidad})')),
          ],
        ),
      ),
    );
  }
}

