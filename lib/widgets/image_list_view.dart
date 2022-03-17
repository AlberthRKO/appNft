import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ImageListView extends StatefulWidget {
  ImageListView({
    Key? key,
    required this.starIndex,
    this.duracion = 30,
  }) : super(key: key);

  final int starIndex;
  final int duracion;

  @override
  State<ImageListView> createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      // si esta terminando la lista ejecuta la animacion denuevo
      if (_scrollController.position.atEdge) {
        _autoScrooll();
      }
    });

    // nos aseguramos si el controlador ha sido ejecutado y si se hizo hace la funcion
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _autoScrooll();
    });
  }

  // funcion de auto scroll
  _autoScrooll() {
    // definimos la posicion actual de desplazamiento
    final _currentScrollPosition = _scrollController.offset;

    final _scrollEndPosition = _scrollController.position.maxScrollExtent;

    // indicamos una animacion , si el inicio de scroll llega al final..vuelve al comienzo
    scheduleMicrotask(() {
      _scrollController.animateTo(
          _currentScrollPosition == _scrollEndPosition ? 0 : _scrollEndPosition,
          duration: Duration(seconds: widget.duracion),
          curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 1.96 * pi,
      child: SizedBox(
        // width: 200,
        height: 120,
        // creamos el list view indicando la direccion y inicio de recorrido de imagen
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return _ImageTile(
                image: 'assets/nfts/${widget.starIndex + index}.png');
          },
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image,
      child: Image.asset(
        image,
        width: 120,
      ),
    );
  }
}
