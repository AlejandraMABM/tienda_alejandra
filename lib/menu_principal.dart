import 'package:flutter/material.dart';
import 'app_routes.dart'; // Importa las rutas

class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
             //   Navigator.pushNamed(context, AppRoutes.crearProducto);
              Navigator.pushNamed(context, AppRoutes.crearProducto);
              },
              child: Text('Crear Producto'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.mostrarProducto);
              },
              child: Text('Mostrar Producto'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.mostrarInventario);
              },
              child: Text('Mostrar Inventario'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.eliminarProducto);
              },
              child: Text('Eliminar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}