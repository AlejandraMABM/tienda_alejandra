import 'package:flutter/material.dart';

class CategoriasCheckbox2 extends StatefulWidget {
  const CategoriasCheckbox2({super.key});

  @override
  State<CategoriasCheckbox2> createState() => _CategoriasCheckboxState();
}

class _CategoriasCheckboxState extends State<CategoriasCheckbox2> {
  final List<String> categorias = [
    'Informática',
    'Electrodomésticos',
    'Música',
    'Mensaje hogar',
    'Monedas',
  ];

  List<String> seleccionadas = [];
  bool allSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias con Checkboxes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón para seleccionar/deseleccionar todo:
            ElevatedButton(
              onPressed: () {
                setState(() {
                  allSelected = !allSelected;
                  seleccionadas = allSelected
                      ? List.from(categorias)
                      : <String>[];
                });
              },
              child: Text(allSelected ? 'Deseleccionar todo' : 'Seleccionar todo'),
            ),
            const SizedBox(height: 12),

            // Mostrar categorías seleccionadas como chips:
            Wrap(
              spacing: 8,
              children: seleccionadas
                  .map((e) => Chip(label: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Lista de checkboxes en scroll:
            Expanded(
              child: ListView(
                children: categorias.map((opcion) {
                  return CheckboxListTile(
                    title: Text(opcion),
                    value: seleccionadas.contains(opcion),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          seleccionadas.add(opcion);
                        } else {
                          seleccionadas.remove(opcion);
                        }
                        allSelected = seleccionadas.length == categorias.length;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
