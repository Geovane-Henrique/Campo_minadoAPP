import 'package:campominado/app/model/campo_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Ezcampo campo;

  @override
  void initState() {
    super.initState();
    campo = Ezcampo();
  }

//acionado sempre que uma casa e apertada
//deve ser otimizado em breve
  void attButton(int rowIndex, int cowIndex) {
    setState(() {
      campo.createEzmpa(rowIndex, cowIndex);
      campo.updateColor(rowIndex, cowIndex);
      campo.revealZero(rowIndex, cowIndex);
      if (campo.getValue(rowIndex, cowIndex) == 500) {
        campo.showMinas();
        gameOver();
      }
    });
  }

//reseta o mapa
  void resetMap() {
    campo.resetEzMap();
    setState(() {});
  }

//aparece um dialog quando uma mina e apertada
  void gameOver() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game over"),
          content: Text("bomba"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetMap();
                },
                child: Text("Tentar novamente"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 60),
                //botao de reset
                //reseta o mapa com a partida ainda em curso
                child: ElevatedButton(
                    onPressed: () {
                      resetMap();
                    },
                    child: Icon(Icons.refresh)),
              ),
              const Text(
                "campo minado",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        //cria o mapa externo
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              12,
              (rowIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    6,
                    (cowIndex) {
                      return Center(
                          //a casa e seus comportamentos
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                fixedSize: const Size(55, 55),
                                maximumSize: Size(55, 55),
                                minimumSize: Size(55, 55),
                                backgroundColor:
                                    campo.getColor(rowIndex, cowIndex),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 12, 11, 11)),
                              ),
                              onPressed: () {
                                attButton(rowIndex, cowIndex);
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child:
                                    //caso o valor for diferente de 0 a cor for igual a verde e o valor for diferente de 500
                                    campo.getValue(rowIndex, cowIndex) != 0 &&
                                            campo.getColor(
                                                    rowIndex, cowIndex) ==
                                                const Color.fromARGB(
                                                    255, 120, 163, 78) &&
                                            campo.getValue(
                                                    rowIndex, cowIndex) !=
                                                500
                                        //o valor da casa sera exibido na casa
                                        ? Text(
                                            "${campo.getValue(rowIndex, cowIndex)}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                            key: ValueKey<int?>(campo.getValue(
                                                rowIndex, cowIndex)),
                                          ) //caso nao siginifica que apertou uma mina entao as casas exibem o icon de warnig
                                        //o icon sera mudado
                                        : Icon(
                                            campo.getIcon(rowIndex, cowIndex),
                                            key: ValueKey<String>(
                                                'icon_${rowIndex}_${cowIndex}'),
                                          ),
                              )));
                    },
                  ),
                );
              },
            ),
          ),
        ));
  }
}
