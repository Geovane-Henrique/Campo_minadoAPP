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

  void attButton(int rowIndex, int cowIndex) {
    setState(() {
      campo.createEzmpa(rowIndex, cowIndex);
      campo.updateColor(rowIndex, cowIndex);
      campo.revealZero(rowIndex, cowIndex);
      if (campo.getValue(rowIndex, cowIndex) == 500) {
        gameOver();
        campo.resetEzMap();
      }
    });
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game over"),
          content: Text("bomba"),
          actions: <Widget>[
            TextButton(
                onPressed: Navigator.of(context).pop,
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
          title: null,
          flexibleSpace: const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(right: 100),
              child: Text(
                "campo minado",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
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
                              child: AnimatedOpacity(
                                opacity: campo.getValue(rowIndex, cowIndex) != 0
                                    ? 1.0
                                    : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 30,
                                    ),
                                    campo.getValue(rowIndex, cowIndex) != 0 &&
                                            campo.getColor(
                                                    rowIndex, cowIndex) ==
                                                Colors.green
                                        ? "${campo.getValue(rowIndex, cowIndex)}"
                                        : ""),
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
