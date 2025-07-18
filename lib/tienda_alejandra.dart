import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'models/producto.dart';
import 'services/producto_service.dart';

late ProductoService productoService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final path = '${dir.path}/productos.csv';
  productoService = ProductoService();
  print('productos antes de cargados $productoService');
  productoService.initWithPath(path);
  await productoService.cargarProductos();
  print('productos cargados $productoService');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Productos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductoListPage(),
    );
  }
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

  void _accionDelBoton() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notificación'),
        content: Text('¡Has presionado el botón de notificación!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cierra el diálogo
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
    
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: _accionDelBoton, // Aquí defines la acción
          ),
        ],
      ),
      body: productos.isEmpty
          ? const Center(child: Text('No hay productos'))
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final p = productos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: (p.imagenUrl != null && p.imagenUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                p.imagenUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                              ),
                            ),
                          )
                        : const Icon(Icons.image_not_supported, size: 60),
                    title: Text(p.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('${p.categoria} - \$${p.precio.toStringAsFixed(2)} (x${p.cantidad})'),
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
                        )
                      ],
                    ),
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
}

class ProductoFormPage extends StatefulWidget {
  final Producto? producto;
  const ProductoFormPage({super.key, this.producto});

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  late TextEditingController _n, _p, _c, _img;
  late String _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _n = TextEditingController(text: widget.producto?.nombre ?? '');
    _p = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    _c = TextEditingController(text: widget.producto?.cantidad.toString() ?? '');
    _img = TextEditingController(text: widget.producto?.imagenUrl ?? '');
    _img.addListener(() => setState(() {}));
    _categoriaSeleccionada = widget.producto?.categoria ?? Producto.categoriasDisponibles.first;
  }

  @override
  void dispose() {
    _n.dispose();
    _p.dispose();
    _c.dispose();
    _img.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final nuevo = Producto(
      id: widget.producto?.id ?? UniqueKey().toString(),
      nombre: _n.text.trim(),
      precio: double.parse(_p.text.trim()),
      cantidad: int.parse(_c.text.trim()),
      categoria: _categoriaSeleccionada,
      imagenUrl: _img.text.trim().isEmpty ? null : _img.text.trim(),
    );
    print("guardando producto: $nuevo");
    if (widget.producto == null) {
      productoService.addProducto(nuevo);
    } else {
      productoService.updateProducto(nuevo);
    }
    await productoService.guardarProductos();
    if (mounted) Navigator.pop(context, true);
  }

  void _cancelar() {
    Navigator.pop(context, false);
  }

  void _borrarCampos() {
    setState(() {
      _n.clear();
      _p.clear();
      _c.clear();
      _img.clear();
      _categoriaSeleccionada = Producto.categoriasDisponibles.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.producto != null;
    return Scaffold(
      appBar: AppBar(title: Text(edit ? 'Editar Producto' : 'Nuevo Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _n,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _p,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (v) => double.tryParse(v!.trim()) == null ? 'Número inválido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _c,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                validator: (v) => int.tryParse(v!.trim()) == null ? 'Número inválido' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                items: Producto.categoriasDisponibles
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _categoriaSeleccionada = v!),
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _img,
                decoration: const InputDecoration(labelText: 'URL de Imagen'),
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
              Container(
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (_img.text.trim().isEmpty)
                      ? const Icon(Icons.image_not_supported, size: 100)
                      : Image.network(
                          _img.text.trim(),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
                  ElevatedButton(onPressed: _cancelar, child: const Text('Cancelar')),
                  ElevatedButton(
                    onPressed: _borrarCampos,
                    //style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 234, 229, 229)),
                    child: const Text('Borrar Campos'),
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




