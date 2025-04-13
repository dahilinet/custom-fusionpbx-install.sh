#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh
. ./environment.sh

#send a message
verbose "Configuring PHP"

#add the repository
if [ ."$os_name" = ."Ubuntu" ]; then
	#24.04.x - /*noble/
        if [ ."$os_codename" = ."noble" ]; then
                echo "Ubuntu 24.04 LTS\n"
                which add-apt-repository || apt-get install -y software-properties-common
                LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
        fi

elif [ ."$cpu_architecture" = ."arm" ]; then
	echo "arm"
fi
apt-get update -y

#install dependencies
apt-get install -y nginx

if [ ."$php_version" = ."8.4" ]; then
        apt-get install -y php8.4 php8.4-cli php8.4-fpm php8.4-pgsql php8.4-sqlite3 php8.4-odbc php8.4-curl php8.4-imap php8.4-xml php8.4-gd php8.4-mbstring
fi


#update config if source is being used
if [ ."$php_version" = ."8.4" ]; then
        verbose "version 8.4"
        php_ini_file='/etc/php/8.4/fpm/php.ini'
fi


sed 's#post_max_size = .*#post_max_size = 80M#g' -i $php_ini_file
sed 's#upload_max_filesize = .*#upload_max_filesize = 80M#g' -i $php_ini_file
sed 's#;max_input_vars = .*#max_input_vars = 8000#g' -i $php_ini_file
sed 's#; max_input_vars = .*#max_input_vars = 8000#g' -i $php_ini_file

#install ioncube
if [ .$cpu_architecture = .'x86' ]; then
	. ./ioncube.sh
fi

#restart php-fpm
systemctl daemon-reload
if [ ."$php_version" = ."8.4" ]; then
        systemctl restart php8.4-fpm
fi

#init.d
#/usr/sbin/service php5-fpm restart
#/usr/sbin/service php7.0-fpm restart
