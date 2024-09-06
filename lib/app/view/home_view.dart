import 'dart:async';

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
  final TextEditingController rowEdit = TextEditingController();
  final TextEditingController cowEdit = TextEditingController();
  final TextEditingController minaEdit = TextEditingController();

  int? row = 12;
  int? cow;
  int? minas;
  late int showtime;
  late Timer time;
  bool gameActive = false;
  int timerG = 0;
  int first = 0;
  late int? selectDif = 1;

  @override
  void initState() {
    super.initState();
    campo = Ezcampo(row: 12, cow: 6);
  }

  void startTime() {
    const durantion = Duration(seconds: 1);
    time = Timer.periodic(durantion, (timer) {
      if (!gameActive) {
        timer.cancel();
      } else {
        setState(() {
          timerG++;
        });
      }
    });
  }

  void startGame() {
    timerG = 0;
    gameActive = true;
    startTime();
  }

//acionado sempre que uma casa e apertada
//deve ser otimizado em breve
  void attButton(int rowIndex, int cowIndex) {
    setState(() {
      campo.createEzmpa(rowIndex, cowIndex);
      campo.updateColor(rowIndex, cowIndex);
      campo.revealZero(rowIndex, cowIndex);

      if (first == 0) {
        startGame();
        first = 1;
      }

      if (campo.getValue(rowIndex, cowIndex) == 500) {
        campo.showMinas();
        gameOver();
        showtime = timerG;
        timerG = 0;
        gameActive = false;

        first = 0;
      }
      if (campo.winGame() == 1) {
        campo.showMinas();
        winDialog();
        showtime = timerG;
        timerG = 0;
        gameActive = false;
        first = 0;
      }
    });
  }

//dialog de vitoria
  void winDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("victory"),
          content: Text("$showtime segundos"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetMap();
              },
              child: Text("jogar novamente"),
            ),
          ],
        );
      },
    );
  }

  //dialog de vitoria
  void personalizeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("crie seu campo"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: rowEdit,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "numero de linhas",
                    border: OutlineInputBorder()),
              ),
              TextField(
                controller: cowEdit,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "numero de colunas",
                    border: OutlineInputBorder()),
              ),
              TextField(
                controller: minaEdit,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "numero de minas", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                row = int.tryParse(rowEdit.text);
                cow = int.tryParse(cowEdit.text);
                minas = int.tryParse(minaEdit.text);
                updateMap();
                Navigator.of(context).pop();
              },
              child: Text("criar"),
            ),
          ],
        );
      },
    );
  }

//reseta o mapa
  void resetMap() {
    gameActive = false;
    timerG = 0;
    campo.resetEzMap();
    first = 0;
    setState(() {});
  }

//atualiza o mapa conforme sua dificuldade
  void updateMap() {
    setState(() {
      if (selectDif == 1) {
        timerG = 0;
        gameActive = false;
        first = 0;
        campo.updateMina(10);
        campo.updateMap(12, 6);
      }
      if (selectDif == 2) {
        timerG = 0;
        gameActive = false;
        first = 0;

        campo.updateMina(35);
        campo.updateMap(20, 10);
      }

      if (selectDif == 3) {
        gameActive = false;
        timerG = 0;
        first = 0;

        campo.updateMina(75);
        campo.updateMap(27, 13);
      }
      if (selectDif == 4) {
        gameActive = false;
        timerG = 0;
        first = 0;

        if (row != null && cow != null && minas != null) {
          campo.updateMina(minas!);
          campo.updateMap(row!, cow!);
        }
      }
    });
  }

//aparece um dialog quando uma mina e apertada
  void gameOver() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return gameOverDialog(resetMap: resetMap, showTime: showtime);
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
                Expanded(
                  child: SizedBox(
                    child: DropdownButton<int>(
                      hint: Text("escolha uma dificuldade"),
                      value: selectDif,
                      onChanged: (int? newvalue) {
                        setState(() {
                          selectDif = newvalue;
                          if (selectDif == 4) {
                            personalizeDialog();
                          }
                          updateMap();
                          resetMap();
                        });
                      },
                      items: const [
                        DropdownMenuItem<int>(child: Text("facil"), value: 1),
                        DropdownMenuItem<int>(child: Text("medio"), value: 2),
                        DropdownMenuItem<int>(child: Text("dificil"), value: 3),
                        DropdownMenuItem<int>(
                            child: Text("personalize"), value: 4)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  //botao de reset
                  //reseta o mapa com a partida ainda em curso
                  child: ElevatedButton(
                      onPressed: () {
                        resetMap();
                      },
                      child: Icon(Icons.refresh)),
                ),
                Text("$timerG"),
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
                : selectDif == 3
                    ? map(
                        campo: campo,
                        attButton: attButton,
                        c: 27,
                        r: 13,
                        selectDif: 3,
                      )
                    : map(
                        campo: campo,
                        attButton: attButton,
                        c: row ?? 0,
                        r: cow ?? 0,
                        selectDif: 4,
                      ));
  }
}
