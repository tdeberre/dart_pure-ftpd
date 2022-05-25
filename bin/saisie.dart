import 'dart:io';
//cette classe permet de faciliter les saisies sur la vue
class Saisir {
//saisie des entiers
  static int entier() {
    int saisie;
    try {
      saisie = int.parse(stdin.readLineSync().toString());
    } catch (e) {
      print(e.toString());
      saisie = entier();
    }
    return saisie;
  }

//saisie des string
  static String text() {
    String saisie;
    try {
      saisie = stdin.readLineSync().toString();
    } catch (e) {
      print(e.toString());
      saisie = text();
    }
    return saisie;
  }

//saisie des string caché
  static String mdp() {
    String saisie;
    try {
      stdin.echoMode = false;
      saisie = stdin.readLineSync().toString();
      stdin.echoMode = true;
    } catch (e) {
      print(e.toString());
      saisie = mdp();
    }
    return saisie;
  }
}