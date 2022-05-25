import 'dart:io';

class F2B {
  static install() async {
    //le script est mis dans une liste
    List<String> script = [
      "apt update",
      "apt install fail2ban -y",
      "echo '[pure-ftpd]' >> /etc/fail2ban/jail.d/defaults-debian.conf",
      "echo 'enabled = true' >> /etc/fail2ban/jail.d/defaults-debian.conf",
      "echo 'bantime = 600' >> /etc/fail2ban/jail.d/defaults-debian.conf",
      "echo 'findtime = 3600' >> /etc/fail2ban/jail.d/defaults-debian.conf",
      "echo 'maxretry = 3' >> /etc/fail2ban/jail.d/defaults-debian.conf"
    ];
      //on execute chaque ligne de la liste
    for (String cmd in script) {
      await Process.run('bash', ['-c', cmd]).then((result) {
        print(result.stdout);
        print(result.stderr);
      });
    }
  }
}
