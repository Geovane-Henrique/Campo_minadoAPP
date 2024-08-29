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
            };
          });
        });

  int getName(int rowIndex, int cowIndex) {
    return mapaez[rowIndex][cowIndex]["name"];
  }

  Color getColor(int rowIndex, int cowIndex) {
    return mapaez[rowIndex][cowIndex]["color"];
  }

  void updateColor(int rowIndex, int cowIndex) {
    mapaez[rowIndex][cowIndex]["color"] = Colors.green;
  }

  int? getValue(int rowIndex, int cowIndex) {
    return mapaez[rowIndex][cowIndex]["value"];
  }

  void revealZero(int rowIndex, int cowIndex) {
    if (mapaez[rowIndex][cowIndex]["value"] == 0) {
      for (int l = -1; l < 2; ++l) {
        for (int c = -1; c < 2; ++c) {
          int checkRow = rowIndex + l;
          int checkColumn = cowIndex + c;

          if (checkRow >= 0 &&
              checkRow < 12 &&
              checkColumn >= 0 &&
              checkColumn < 6) {
            if (mapaez[checkRow][checkColumn]["value"] == 0 &&
                mapaez[checkRow][checkColumn]["color"] == Colors.blue) {
              mapaez[checkRow][checkColumn]["color"] = Colors.green;
              revealZero(checkRow, checkColumn);
            }
            mapaez[checkRow][checkColumn]["color"] = Colors.green;
          }
        }
      }
    }
  }

  createEzmpa(int r, int c) {
    while (end == 0) {
      mapaez[r][c]["value"] = 100;
      revealZero(r, c);

      for (int lr = -1; lr < 2; lr++) {
        for (int lc = -1; lc < 2; lc++) {
          int rowMarking = r + lr;
          int columnMarking = c + lc;

          if (rowMarking >= 0 &&
              rowMarking < 12 &&
              columnMarking >= 0 &&
              columnMarking < 6) {
            mapaez[rowMarking][columnMarking]["value"] = 100;
          }
        }
      }

      for (int i = 1; i <= 10; i) {
        int linha = random.nextInt(12);
        int coluna = random.nextInt(6);

        if (mapaez[linha][coluna]["value"] == 0) {
          mapaez[linha][coluna]["value"] = 500;
          ++i;
        }
      }

      for (int i = 0; i < 12; ++i) {
        for (int l = 0; l < 6; ++l) {
          if (mapaez[i][l]["value"] == 100) {
            mapaez[i][l]["value"] = 0;
          }

          if (mapaez[i][l]["value"] == 0) {
            for (int lr = -1; lr < 2; lr++) {
              for (int lc = -1; lc < 2; lc++) {
                int rowcount = i + lr;
                int columncount = l + lc;
                if (rowcount >= 0 &&
                    rowcount < 12 &&
                    columncount >= 0 &&
                    columncount < 6) {
                  if (mapaez[rowcount][columncount]["value"] == 500) {
                    mapaez[i][l]["value"] = mapaez[i][l]["value"]! + 1;
                  }
                }
              }
            }
          }
        }
      }
      end++;
    }
  }

  resetEzMap() {
    for (int i = 0; i <= 11; ++i) {
      for (int l = 0; l <= 5; ++l) {
        mapaez[i][l]["value"] = 0;
        mapaez[i][l]["color"] = Colors.blue;
      }
    }
    end = 0;
  }
}
