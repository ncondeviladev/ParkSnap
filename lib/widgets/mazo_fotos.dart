import 'dart:io';

import 'package:flutter/material.dart';

class MazoFotos extends StatefulWidget {
  const MazoFotos({super.key, required this.fotos});

  final List<String> fotos;

  @override
  State<MazoFotos> createState() => _MazoFotosState();
}

class _MazoFotosState extends State<MazoFotos> {
  bool _estaDesplegado = false;

  @override
  Widget build(BuildContext context) {
    //Si no hay fotos no se dibuja nada
    if (widget.fotos.isEmpty) return const SizedBox.shrink();

    // GestureDetector para detectar toques
    return GestureDetector(
      onTap: () {
        //Pliega y despliega
        setState(() {
          _estaDesplegado = !_estaDesplegado;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 120,
        // Si desplegado, ancho total, si no, ancho fijo
        width: _estaDesplegado ? MediaQuery.of(context).size.width : 130,
        decoration: BoxDecoration(
          // Fondo oscuro traslucido al desplegar para resaltar
          color: _estaDesplegado ? Colors.black54 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _estaDesplegado
            ? _construirListaDesplegada()
            : _construirMazoApilado(),
      ),
    );
  }

  Widget _construirListaDesplegada() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.fotos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: GestureDetector(
            // Al tocar foto individual, abrirla en grande
            onTap: () => _abrirFoto(widget.fotos[index]),
            child: Hero(
              // Animacion hero para transicion suave
              tag: widget.fotos[index],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(widget.fotos[index]),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _construirMazoApilado() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(widget.fotos.length, (index) {
        if (index > 1) return const SizedBox.shrink();

        return Transform.translate(
          //Desplaza progresivo
          offset: Offset(index * 4.0, index * 2.0),
          child: Transform.rotate(
            angle: index * 0.1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 4, color: Colors.black45),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(widget.fotos[index]),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).reversed.toList(), // Invertimos para que la ultima sea la primera
    );
  }

  void _abrirFoto(String foto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Hero(tag: foto, child: Image.file(File(foto))),
            ),
          ),
        ),
      ),
    );
  }
}
