import 'package:flutter/material.dart';
import 'package:tienda_alejandra/pages/categoria_radio_buttom';
//import 'package:tienda_alejandra/pages/categorias_checbosx2.dart';
//import 'package:tienda_alejandra/pages/categorias.dart';
//import 'package:tienda_alejandra/pages/categorias_checbox.dart';
//import 'package:tienda_alejandra/pages/mitienda.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda',
      
   //   home: Mitienda(),
   //   home: Categorias(),
   //   home: CategoriasCheckbox(),
   //  home: CategoriasCheckbox2(),
    home: CategoriasRadio(),
   

    );
  }
}

