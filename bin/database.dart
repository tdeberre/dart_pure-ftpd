import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'session.dart';

class DB {
  //attribut
   static late Session masession;
  //setter
  static setSession(user,password) {
    DB.masession = Session(user,password);
  }

  //gestion des parametres
  //changer la valeur d'une option dans la db
  static changeroption(String nomoption, String nouvvaleur) {
    DB.masession.query(
      "UPDATE `Options` SET `Valeur` = '$nouvvaleur' WHERE `Options`.`Option` = '$nomoption';");
  }
  //ajouter une option dans la db
  static ajouteroption(String nomoption, String nouvvaleur) {
    DB.masession.query(
      "INSERT INTO `Options` (`Option`, `Valeur`) VALUES ('$nomoption', '$nouvvaleur');");
  }
  //sauvegarde les option de la db dans le dossier save
  static save(String nomsave) async {
    await Process.run('bash', [
      '-c',
      //"pwd"  
      "mysqldump --user=${DB.masession.getsettings().user} --password=${DB.masession.getsettings().password} pureftpDB > saves/$nomsave.sql"
    
    ]).then((result) {
      print(result.stdout);
      print(result.stderr);
    });
  }

  //gestion des sauvegardes
  //charge une sauvegardé dans la db
  static load(String nomsave) async {
    await Process.run(
            'bash', ['-c', "mysql --user=${DB.masession.getsettings().user} --password=${DB.masession.getsettings().password} --database=pureftpDB < saves/$nomsave.sql"])
        .then((result) {
      print(result.stdout);
      print(result.stderr);
    });
  }
  //transphorme les options de la base de donnée en wrappers
  static chargeroptions() async {
    List<List<String>> mesoptions = await DB.tabOptions();
    for (var i = 0; i < mesoptions[0].length; i++) {
      await Process.run('bash', [
        '-c',
        "echo '${mesoptions[1][i]}' > /etc/pure-ftpd/conf/${mesoptions[0][i]}"
      ]);
    }
  }

  //retourne un tableau avec les options dans la db et leurs valeur
  static Future<List<List<String>>> tabOptions() async {
    List<String> lesoptions = List.empty(growable: true);
    List<String> lesvaleurs = List.empty(growable: true);
    Results reponse;
    reponse = await DB.masession.query("SELECT Option FROM Options;");
    for (var option in reponse) {
      lesoptions.add(option.fields["Option"]);
    }
    reponse = await DB.masession.query("SELECT Valeur FROM Options;");
    for (var valeur in reponse) {
      lesvaleurs.add(valeur.fields["Valeur"]);
    }
    return [lesoptions, lesvaleurs];
  }

  //initialisation
  static checkDB() async {
    //verification de la db
    await Process.run('bash', ['-c', "mysqlshow pureftpDB"])
        .then((result) async {
      if (result.stderr == "mysqlshow: Unknown database 'pureftpDB'\n") {
        //creation si besoin
        await Process.run(
                'bash', ['-c', "mysql -f -v -e 'create database pureftpDB;'"])
            .then((result) {
          print(result.stdout);
          print(result.stderr);
        });
      }
    });
    //verification de la table
    await Process.run('bash', ['-c', "mysqlshow pureftpDB -t Options"])
        .then((result) async {
      if (result.stderr ==
          "mysqlshow: Unknown database 'pureftpDB.Options'\n") {
        //creation si besoin
        await Process.run('bash', [
          '-c',
          "mysql -f -v -D 'pureftpDB' -e 'create table Options (Option varchar(50) primary key not null , Valeur varchar(50) not null);'"
        ]).then((result) {
          print(result.stdout);
          print(result.stderr);
        });
      }
    });
    //donner les droits sur la db
    Process.run('bash', ['-c',
      "mysql -f -v -e \"grant all privileges on pureftpDB.* to dartuser@localhost identified by'btsinfo';\""
    ]).then((result) {
          print(result.stdout);
          print(result.stderr);
        });
        Process.run('bash', ['-c',
      "mysql -f -v -e 'flush privileges;'"
    ]).then((result) {
          print(result.stdout);
          print(result.stderr);
        });
  }

  //relancer le service pure-ftpd pour prendre les changements de configuration en compte
  static ftpreload() async {
    Process.run('bash', ['-c',"service pure-ftpd restart"]).then((result) {
      print(result.stdout);
      print(result.stderr);
    });
  }

}