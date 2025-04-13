#!/bin/sh

sudo add-apt-repository ppa:ondrej/php -y

sudo apt install nginx -y

apt install php8.4 php8.4-cli php8.4-common php8.4-curl php8.4-fpm php8.4-gd php8.4-imap php8.4-mbstring php8.4-odbc php8.4-opcache php8.4-pgsql php8.4-readline php8.4-sqlite3 php8.4-xml


sudo systemctl restart nginx
sudo systemctl restart php8.4-fpm


#upgrade the packages
apt-get update && apt-get upgrade -y

#install packages
apt-get install -y git lsb-release

# we all ready get it
# cd /usr/src && git clone https://github.com/fusionpbx/fusionpbx-install.sh.git

#change the working directory
cd /usr/src/fusionpbx-install.sh/ubuntu
