import 'package:flutter/material.dart';

class Bandera extends StatelessWidget {
const Bandera({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(child: pintarEstrellas(69),),
    );Container();
  }
}

Container pintarEstrellas(double pixeles)
{

  return Container(

color: Colors.blue,
alignment: Alignment.center,
height: pixeles * 5,
width: pixeles * 8,
child: Stack(
  children: [
    Container(
      margin: EdgeInsets.only(left: pixeles * 4),
    child: Transform.rotate(angle: 5*3.1416/180,
   // Icon(Icons.star),
    child: Icon(Icons.star, color: Colors.white, size: pixeles),
    ),
    ),
  ],
),

  );
}