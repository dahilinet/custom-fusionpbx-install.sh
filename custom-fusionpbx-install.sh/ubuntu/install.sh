#!/bin/sh

sudo add-apt-repository ppa:ondrej/php -y

sudo apt install nginx -y

apt install php8.4 php8.4-cli php8.4-common php8.4-curl php8.4-fpm php8.4-gd php8.4-imap php8.4-mbstring php8.4-odbc php8.4-opcache php8.4-pgsql php8.4-readline php8.4-sqlite3 php8.4-xml -y


sudo systemctl restart nginx
sudo systemctl restart php8.4-fpm



#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./resources/config.sh
. ./resources/colors.sh
. ./resources/environment.sh

# removes the cd img from the /etc/apt/sources.list file (not needed after base install)
sed -i '/cdrom:/d' /etc/apt/sources.list

#Update to latest packages
verbose "Update installed packages"
apt-get update && apt-get upgrade -y

#Add dependencies
apt-get install -y wget
apt-get install -y lsb-release
apt-get install -y systemd
apt-get install -y systemd-sysv
apt-get install -y ca-certificates
apt-get install -y dialog
apt-get install -y nano
apt-get install -y nginx
apt-get install -y build-essential

#SNMP
apt-get install -y snmpd
echo "rocommunity public" > /etc/snmp/snmpd.conf
service snmpd restart

#IPTables
resources/iptables.sh

#sngrep
resources/sngrep.sh

#FusionPBX
resources/fusionpbx.sh

#PHP
resources/php.sh

#NGINX web server
resources/nginx.sh

#Postgres
resources/postgresql.sh

#Optional Applications
resources/applications.sh

#FreeSWITCH
resources/switch.sh

#Fail2ban
resources/fail2ban.sh

#set the ip address
server_address=$(hostname -I)

#add the database schema, user and groups
resources/finish.sh
