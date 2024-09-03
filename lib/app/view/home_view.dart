import 'package:campominado/app/model/maoEz.dart';

import 'package:campominado/app/view/maps_view.dart';
import 'package:flutter/material.dart';

import 'gameOverDialog_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Ezcampo campo;

  late int? selectDif = 1;

  @override
  void initState() {
    super.initState();
    campo = Ezcampo(row: 12, cow: 6);
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

  void updateMap() {
    setState(() {
      if (selectDif == 1) {
        campo.updateMina(10);
        campo.updateMap(12, 6);
      }
      if (selectDif == 2) {
        campo.updateMina(35);
        campo.updateMap(20, 10);
      }

      if (selectDif == 3) {
        campo.updateMina(75);
        campo.updateMap(27, 13);
      }
    });
  }

//aparece um dialog quando uma mina e apertada
  void gameOver() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return gameOverDialog(resetMap: resetMap);
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenWidth, screenHeight * 0.08),
          child: AppBar(
            backgroundColor: Colors.black,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  hint: Text("escolha uma dificuldade"),
                  value: selectDif,
                  onChanged: (int? newvalue) {
                    setState(() {
                      selectDif = newvalue;
                      updateMap();
                      resetMap();
                      updateMap();
                    });
                  },
                  items: const [
                    DropdownMenuItem<int>(child: Text("facil"), value: 1),
                    DropdownMenuItem<int>(child: Text("medio"), value: 2),
                    DropdownMenuItem<int>(child: Text("dificil"), value: 3),
                  ],
                ),
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
              ],
            ),
          ),
        ),

        //cria o mapa externo
        body: selectDif == 1
            ? map(
                campo: campo,
                attButton: attButton,
                c: 12,
                r: 6,
                selectDif: 1,
              )
            : selectDif == 2
                ? map(
                    campo: campo,
                    attButton: attButton,
                    c: 20,
                    r: 10,
                    selectDif: 2,
                  )
                : map(
                    campo: campo,
                    attButton: attButton,
                    c: 27,
                    r: 13,
                    selectDif: 3,
                  ));
  }
}
