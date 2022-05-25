import 'dart:io';
import 'saisie.dart';
import 'database.dart';
import 'installftp.dart';
import 'installf2b.dart';

class Vue {
  //nettoie l'ecran
  static clear() {
    print("\x1B[2J");
  }

  //se connecte a la base de donnée
  static ecranconnection() {
    print("\n---Connection---\n");
    print("identifiant :");
    String id = Saisir.text();
    print("mot de passe :");
    String pass = Saisir.mdp();
    DB.setSession(id, pass);
  }

  //menu principal
  static menu() async {
    print("\n---Menu---\n");
    print("1 - initalisation");
    print("2 - installer pureftpd");
    print("3 - Parametres du ftp");
    print("4 - Sauvegardes");
    print("5 - installer fail2ban");
    int choix = Saisir.entier();
    print("\x1B[2J");
    switch (choix) {
      case 1:
        await DB.checkDB();
        menu();
        break;
      case 2:
        await FTP.install();
        menu();
        break;
      case 3:
        await Vue.menuParametres();
        break;
      case 4:
        await Vue.menuSauvegardes();
        break;
      case 5:
        await F2B.install();
        menu();
        break;
      default:
        menu();
    }
  }

  //menu des parametres
  static menuParametres() async {
    print("\n---Menu des parametres---\n");
    print("1 - afficher les parametres");
    print("2 - charger les parametres");
    print("3 - ajouter un parametres");
    print("4 - charger les parametres");
    print("5 - retour au menu principale");
    int choix = Saisir.entier();
    print("\x1B[2J");
    switch (choix) {
      case 1:
        await Vue.afficheroptions();
        menuParametres();
        break;
      case 2:
        List<String> option = Vue.demandeoption();
        DB.changeroption(option[0], option[1]);
        menuParametres();
        break;
      case 3:
        List<String> option = Vue.demandeoption();
        DB.ajouteroption(option[0], option[1]);
        menuParametres();
        break;
      case 4:
        await DB.chargeroptions();
        menuParametres();
        break;
      case 5:
        menu();
        break;
      default:
    }
  }

  //affiche les options dans la bd
  static afficheroptions() async {
    List<List<String>> lesoptions = await DB.tabOptions();
    print("\n---Options---\n");
    for (var i = 0; i < lesoptions[0].length; i++) {
      stdout.write("${lesoptions[0][i]} : ");
      stdout.write("${lesoptions[1][i]}\n");
    }
  }
  
  //menu pour changer une option
  static List<String> demandeoption() {
    print("quelle le nom de option ?");
    String nomoption = Saisir.text();
    print("quelle est la nouvelle valeur ?");
    String nouvvaleur = Saisir.text();
    return [nomoption, nouvvaleur];
  }

  //menu des sauvegardes
  static menuSauvegardes() async {
    print("\n---Menu des sauvegardes---\n");
    print("1 - sauver les parametres");
    print("2 - charger une sauvegarde");
    print("3 - retour au menu principale");
    int choix = Saisir.entier();
    print("\x1B[2J");
    switch (choix) {
      case 1:
        print("Nom de la sauvegarde :");
        await DB.save(Saisir.text());
        menuSauvegardes();
        break;
      case 2:
        print("Nom de la sauvegarde :");
        await DB.load(Saisir.text());
        menuSauvegardes();
        break;
      case 3:
        menu();
        break;
      default:
    }
  }

}
