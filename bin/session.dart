import 'package:mysql1/mysql1.dart';
import 'vue.dart';
import 'database.dart';

//cette class permet de garder les identifiants saisi au lancement pour lancer les requetes plus facilement
//les requetes dans la class DB sont plus compacte et plus lisible
class Session {
  //attributs
  late ConnectionSettings _settings;
  //constructeur
  Session(user, password) {
    _settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: '$user',
      password: '$password',
      db: 'pureftpDB',
    );
  }
  //getters
  ConnectionSettings getsettings() => _settings;
  
  //fonctions
  Future<Results> query(String request) async {
    dynamic reponse;
    try {
      MySqlConnection connexion = await MySqlConnection.connect(_settings);
      try {
        reponse = await connexion.query(request);
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
      Vue.ecranconnection();
      reponse = DB.masession.query(request);
    }
    return reponse;
  }
}
