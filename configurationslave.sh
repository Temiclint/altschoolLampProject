#!/usr/bin/bash

#slave server config 


set -e

vagrant ssh slave <<EOF
  
sudo apt install apache2 -y
sudo ufw allow in "Apache"
sudo ufw status
sudo apt install mysql-server -y
sudo chown -R www-data:www-data /var/www
sudo apt install php libapache2-mod-php php-mysql -y
sudo a2enmod rewrite
sudo phpenmod mcrypt
sudo sed -i 's/DirectoryIndex index.html index.cgi index.pl index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf
sudo systemctl reload apache2
exit 0
EOF
