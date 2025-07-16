import 'package:flutter/material.dart';
import 'package:tienda_alejandra/services/producto_service.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

 

  @override
  Widget build(context) {
     final productoService = ProductoService();
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
            const Text(
              'Productos únicos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
            const Text(
              'Por categoría:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (byCat.isEmpty)
              const Text('Nada')
            else
              ...byCat.entries.expand(
                (e) => [
                  Text(
                    e.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...e.value.map(
                    (p) => Text('  • ${p.nombre} (Cant: ${p.cantidad})'),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Text(
              'Stock bajo (<10):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
