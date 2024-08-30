import 'dart:math';

import 'package:flutter/material.dart';

class Ezcampo {
  List<List<Map<String, dynamic>>> mapaez;
  int end = 0;

  Random random = Random();

  Ezcampo()
      : mapaez = List.generate(12, (rowIndex) {
          return List.generate(6, (cowIndex) {
            return {
              "name": rowIndex * 6 + cowIndex + 1,
              "value": 0,
              "color": Colors.blue,
              "icon": null
            };
          });
        });

// retorna o nome foi (usado para teste)
  int getName(int rowIndex, int cowIndex) {
    return mapaez[rowIndex][cowIndex]["name"];
  }

  //retorna a cor do background das casas
  Color getColor(int rowIndex, int cowIndex) {
    return mapaez[rowIndex][cowIndex]["color"];
  }

  //atualiza a cor da casa apos o click
  void updateColor(int rowIndex, int cowIndex) {
    if (mapaez[rowIndex][cowIndex]["value"] != 500) {
      mapaez[rowIndex][cowIndex]["color"] =
          const Color.fromARGB(255, 120, 163, 78);
    }
  }

  //retorna o valor da casa(determina o que a casa e, uma mina um 1,2,3 etc...)
  int getValue(int rowIndex, int cowIndex) {
    return mapaez[rowIndex][cowIndex]["value"];
  }

//retorna o icon da mina
  IconData? getIcon(int rowIndex, int cowIndex) {
    return mapaez[rowIndex][cowIndex]["icon"];
  }

//quando uma casa com o valor "0" e apertada o valor das casas ao redor são revelados
//caso seja revelado um zero o proxedimento se repete
  void revealZero(int rowIndex, int cowIndex) {
    //verifica se o valor da casa e "0"
    if (mapaez[rowIndex][cowIndex]["value"] == 0) {
      //seleciona as casas ao redor(3x3)
      for (int l = -1; l < 2; ++l) {
        for (int c = -1; c < 2; ++c) {
          //define a linha e coluna da casa a ser revelada
          int checkRow = rowIndex + l;
          int checkColumn = cowIndex + c;
// garante que a casa a ser verificada existe
          if (checkRow >= 0 &&
              checkRow < 12 &&
              checkColumn >= 0 &&
              checkColumn < 6) {
            //se a casa verificada tiver o valor de zero e sua cor for azul o procedimeno entra em loop(a cor e precisa para que o loop seja finito e ele não verifique casas ja reveladas)
            if (mapaez[checkRow][checkColumn]["value"] == 0 &&
                mapaez[checkRow][checkColumn]["color"] == Colors.blue) {
              mapaez[checkRow][checkColumn]["color"] =
                  const Color.fromARGB(255, 120, 163, 78);
              revealZero(checkRow, checkColumn);
            }
            //caso a casa não seja um zero
            mapaez[checkRow][checkColumn]["color"] =
                const Color.fromARGB(255, 120, 163, 78);
          }
        }
      }
    }
  }

//cria o mapa
// o mapa e criado apos o primeiro click
// a casa deve ser obrigatoriamente um zero
// recebe a linha e coluna da casa
  void createEzmpa(int r, int c) {
    while (end == 0) {
      //para evitar que a casa vire uma mina lhe e atribuido o valor de 100
      mapaez[r][c]["value"] = 100;
      // verifica se alguma(s) casa(s) são "0"
      revealZero(r, c);

      //estrutura para atribuir o valor momentaneo de 100 as casas ao redor(evitando que vire uma mina)
      for (int lr = -1; lr < 2; lr++) {
        for (int lc = -1; lc < 2; lc++) {
          int rowMarking = r + lr;
          int columnMarking = c + lc;
          //garante que a casa existe
          if (rowMarking >= 0 &&
              rowMarking < 12 &&
              //define a linha e coluna da casa a ser revelada
              columnMarking >= 0 &&
              columnMarking < 6) {
            mapaez[rowMarking][columnMarking]["value"] = 100;
          }
        }
      }
      //cria 10 minas aleatoriamente(valor 5 = mina)
      for (int i = 1; i <= 10; i) {
        int linha = random.nextInt(12);
        int coluna = random.nextInt(6);
        //varifica se a casa nao tem nenhum valor atribuido ainda(as casas ao redir da inicial tem valor 100 e as casas com minas tem valor 500)
        if (mapaez[linha][coluna]["value"] == 0) {
          //atribui o valor de uma mina a casa
          mapaez[linha][coluna]["value"] = 500;
          ++i;
        }
      }
      //olha todas as casas do mapa para atribuir valor as casas com minas ao redor
      for (int i = 0; i < 12; ++i) {
        for (int l = 0; l < 6; ++l) {
          //as casas com valor 100 tem seu valor alterado para 0
          if (mapaez[i][l]["value"] == 100) {
            mapaez[i][l]["value"] = 0;
          }
          //se a casa tiver o valor de 0 o procedimento e iniciado
          if (mapaez[i][l]["value"] == 0) {
            //varifica os aredores da casa selecionada num formato 3x3
            for (int lr = -1; lr < 2; lr++) {
              for (int lc = -1; lc < 2; lc++) {
                //define a linha e coluna da casa ao redor da casa a ser verificada
                int rowcount = i + lr;
                int columncount = l + lc;
                //verifica se a casa existe
                if (rowcount >= 0 &&
                    rowcount < 12 &&
                    columncount >= 0 &&
                    columncount < 6) {
                  //caso a casa ao redor tenha o valor de 500(mina) e lhe atribuido o valor de +1
                  //acontece 9 vezes e determina o valor final da casa
                  //se tiver 4 minas ao redor o valor sera 4
                  if (mapaez[rowcount][columncount]["value"] == 500) {
                    mapaez[i][l]["value"] = mapaez[i][l]["value"]! + 1;
                  }
                }
              }
            }
          }
        }
      }
      //indica o fim da criação do mapa
      end++;
    }
  }

//reseta todos os valores das casas
//basicamente reseta o mapa
  void resetEzMap() {
    for (int i = 0; i <= 11; ++i) {
      for (int l = 0; l <= 5; ++l) {
        mapaez[i][l]["value"] = 0;
        mapaez[i][l]["icon"] = null;
        mapaez[i][l]["color"] = Colors.blue;
      }
    }
    //indica que um novo mapa pode ser criado
    end = 0;
  }

//e chamado quando uma mina e apertada entao lhe atribui o icon de warnig a todas elas
//todas as minas sao reveladas quando ganham um icon
  void showMinas() {
    for (int i = 0; i <= 11; ++i) {
      for (int l = 0; l <= 5; ++l) {
        if (mapaez[i][l]["value"] == 500) {
          mapaez[i][l]["icon"] = Icons.warning;
        }
      }
    }
  }
}
