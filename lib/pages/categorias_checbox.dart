import 'package:flutter/material.dart';

class CategoriasCheckbox extends StatefulWidget {
  const CategoriasCheckbox({super.key});

  @override
  State<CategoriasCheckbox> createState() => _CategoriasCheckboxState();
}

class _CategoriasCheckboxState extends State<CategoriasCheckbox> {
  final List<String> list = <String>[
    'Informática',
    'Electrodomésticos',
    'Música',
    'Mensaje hogar',
    'Monedas',
  ];

  // Lista que almacena las categorías seleccionadas
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccionadas: ${selectedCategories.join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Aquí estaba el error: falta el cierre de map y toList()
            SingleChildScrollView(
              child: Column(
                children: list.map((category) {
                  return CheckboxListTile(
                    title: Text(category),
                    value: selectedCategories.contains(category),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(), // Asegúrate de incluir .toList()
              ),
            ),
          ],
        ),
      ),
    );
  }
}
