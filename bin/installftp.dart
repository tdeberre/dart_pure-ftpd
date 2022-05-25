import 'dart:io';

class FTP {
  //methode pour installer le service pure-ftpd
  static install() async {
    //le script est mis dans une liste
    List<String> script = [
      "apt update",
      "apt install pure-ftpd -y",
      "addgroup ftpuser --gid 9999",
      "useradd ftpuser --uid 9999 --home /home/FTPUSER --create-home --gid 9999 --groups ftpuser",
      "chown root:root /home/FTPUSER",
      "echo 'yes' > /etc/pure-ftpd/conf/CreateHomeDir",
      "ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/60puredb"
    ];
    //on execute chaque ligne de la liste
    for (String cmd in script) {
      await Process.run('bash', ['-c', cmd]).then((result) {
        print(result.stdout);
        print(result.stderr);
      });
    }
    //on creer le premier utilisateur
    Process p = await Process.start('bash', [
      '-c',
      "pure-pw useradd admin -u 9999 -g 9999 -d /home/FTPUSER/admin -m"
    ]);
    stdout.addStream(p.stdout);
    stderr.addStream(p.stderr);
    p.stdin.addStream(stdin);
    //enfin on restart le service
    await Process.run('bash', ['-c', "service pure-ftpd restart"])
        .then((result) {
      print(result.stdout);
      print(result.stderr);
    });
  }
}
