import 'package:campominado/app/model/maoEz.dart';

import 'package:flutter/material.dart';

import 'casa_view.dart';

class map extends StatelessWidget {
  final Ezcampo campo;

  final void Function(int, int) attButton;
  final int c;
  final int selectDif;
  final int r;
  const map({
    super.key,
    required this.campo,
    required this.attButton,
    required this.c,
    required this.r,
    required this.selectDif,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double width;
      double height;
//faz o mapa ficar responsivo
      if (selectDif == 1) {
        width = constraints.maxWidth / 6;
        height = constraints.maxHeight / 12;
      } else if (selectDif == 2) {
        width = constraints.maxWidth / 10;
        height = constraints.maxHeight / 20;
      } else {
        width = constraints.maxWidth / 13;
        height = constraints.maxHeight / 27;
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            c,
            (rowIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  r,
                  (cowIndex) {
                    return selectDif == 1
                        ? casaView(
                            campo: campo,
                            attButton: attButton,
                            width: width,
                            height: height,
                            rowIndex: rowIndex,
                            cowIndex: cowIndex,
                            size: 25,
                            fontsize: 30,
                          )
                        : selectDif == 2
                            ? casaView(
                                campo: campo,
                                attButton: attButton,
                                width: width,
                                height: height,
                                rowIndex: rowIndex,
                                cowIndex: cowIndex,
                                size: 10,
                                fontsize: 15)
                            : casaView(
                                campo: campo,
                                attButton: attButton,
                                width: width,
                                height: height,
                                rowIndex: rowIndex,
                                cowIndex: cowIndex,
                                size: 7,
                                fontsize: 10);
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
