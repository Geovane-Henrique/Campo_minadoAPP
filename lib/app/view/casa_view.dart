import 'package:flutter/material.dart';

import '../model/maoEz.dart';

class casaView extends StatelessWidget {
  final Ezcampo campo;
  final void Function(int, int) attButton;
  final int rowIndex;
  final int cowIndex;
  final double width;
  final double height;
  final double fontsize;
  final double size;
  const casaView(
      {super.key,
      required this.campo,
      required this.attButton,
      required this.width,
      required this.height,
      required this.rowIndex,
      required this.cowIndex,
      required this.fontsize,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: campo.getColor(rowIndex, cowIndex),
              side: const BorderSide(color: Color.fromARGB(255, 12, 11, 11)),
            ),
            onPressed: () {
              attButton(rowIndex, cowIndex);
            },
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    //caso o valor for diferente de 0 a cor for igual a verde e o valor for diferente de 500
                    campo.getValue(rowIndex, cowIndex) != 0 &&
                            campo.getColor(rowIndex, cowIndex) ==
                                const Color.fromARGB(255, 120, 163, 78) &&
                            campo.getValue(rowIndex, cowIndex) != 500
                        //o valor da casa sera exibido na casa
                        ? Text(
                            "${campo.getValue(rowIndex, cowIndex)}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize,
                            ),
                            key: ValueKey<int?>(
                                campo.getValue(rowIndex, cowIndex)),
                          )
                        //caso nao siginifica que apertou uma mina entao as casas exibem o icon de warnig
                        //o icon sera mudado

                        : Icon(
                            campo.getIcon(rowIndex, cowIndex),
                            key: ValueKey<String>(
                                'icon_${rowIndex}_${cowIndex}'),
                            size: size,
                          ),
              ),
            ),
          ),
        ));
  }
}
