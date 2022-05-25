Cette application en dart permet de metre en place le service pure-ftpd, de gerer ses parametres plus facilement, de sauvegarder/charger une configuration pour ce service et de le securiser avec fail2ban.

Lors lancement il faut entrer ses identifiants pour acceder a la base de donnés.

On arrive alors sur le menu principal il ressemble a ca:

  ---Menu---
  1 - initalisation
  2 - installer pureftpd
  3 - Parametres du ftp
  4 - Sauvegardes
  5 - installer fail2ban


Si c'est le premier lancement choisissez initialisation cela va creer une ddb et donner les droits pour celle ci aux les identifiants precedement saisi. il faudra ensuite choisir les services a installer(pure-ftpd ou fail2ban).

Lorsque cela est fait on peut utiliser la fonction parametres pour arriver sur ce menu :

  ---Menu des parametres---
  1 - afficher les parametres
  2 - modifier les parametres
  3 - ajouter un parametres
  4 - charger les parametres
  5 - retour au menu principale
  
  
On peut afficher les parametres saisi, modifier ces derniers ou en ajouter de nouveaux. Pour que les changements soient pris en compte il faut choisir l'option charger les parametres.

Le menu sauvegardes se presente comme ceci:

  ---Menu des sauvegardes---
  1 - sauver les parametres
  2 - charger une sauvegarde
  3 - retour au menu principale
  
Il permet de sauvegarder un ensemble de parametres sous un nom choisi puis de le recharger. Les sauvegardes sont des dump sql donc peuvent etre partagé ou reutilisé il se sutuent dans le dossier 'saves'.
