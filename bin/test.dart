import 'dart:io';

class Test {
  //attributs
  String _host;
  String _username;
  String _password;
  String _db;
  //builder
  Test(this._host, this._username, this._password, this._db);
  //getters
  gethost() => _host;
  getusername() => _username;
  getpassword() => _password;
  getdb() => _db;
  //autres
  dynamic query(cmd) async {
    await Process.run('bash', [
      '-c',
      "mysql -v -u $_username --password=$_password -h $_host -D $_db -e '$cmd'"
    ]).then((result) {
      return result.stdout!=""?result.stdout:result.stderr;
    });
  }
}

  //Test test = new Test("localhost", "dartuser", "btsinfo", "pureftpDB");
  //print(await test.query("select * from Options;"));