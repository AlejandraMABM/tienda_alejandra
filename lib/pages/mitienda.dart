import 'package:flutter/material.dart';
import 'package:tienda_alejandra/pages/bandera.dart';

class Mitienda extends StatefulWidget {
  const Mitienda({Key? key}) : super(key: key);

  @override
  _MitiendaState createState() => _MitiendaState();
}

class _MitiendaState extends State<Mitienda> {
  // declaración de variables


  // generamos las opciones del menu


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Menú Principal Tienda')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bandera()),
              );
            },
            child: const Text('1. Crear Productos'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bandera()),
              );
            },
            child: const Text('2. Mostrar productos'),
          ),
        ],
      ),
    );
  }
}
