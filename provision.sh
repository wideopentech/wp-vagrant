#!/bin/bash

# ==================== CONFIGURATION =========================
# Mysql root password
mysql_root_password=$([ -z "$1" ] && echo 'vagrant' || echo "$1")
ip=$([ -z "$2" ] && echo '127.0.0.1' || echo "$2")
domain=$([ -z "$3" ] && echo 'localhost' || echo "$3")
database_name=$([ -z "$4" ] && echo 'yii2advanced' || echo "$4")
database_user_name=$([ -z "$5" ] && echo 'yii2advanced' || echo "$5")
database_user_password=$([ -z "$6" ] && echo 'yii2advanced' || echo "$6")

if [ -t 0 ]; then
	read -e -p "MySQL root password: " -i "$mysql_root_password" mysql_root_password
	read -e -p "IP: " -i "$ip" ip
	read -e -p "Domain: " -i "$domain" domain
    read -e -p "Database Name: " -i "$database_name" database_name
    read -e -p "Database User: " -i "$database_user_name" database_user_name
    read -e -p "Database Password: " -i "$database_user_password" database_user_password
fi



# ==================== INSTALLATION =========================

# updates
sudo apt-get update;
sudo apt-get install -y python-software-properties

# apache
sudo apt-get install -y apache2

# mysql
echo "mysql-server mysql-server/root_password password $mysql_root_password" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $mysql_root_password" | sudo debconf-set-selections
sudo apt-get install -y mysql-server php5-mysql

# php
sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-curl php5-gd libssh2-php

# node
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

# ruby
sudo apt-get install -y ruby-full
sudo gem update --system
sudo gem install compass
sudo gem install sass





# ==================== SERVER CONFIGURATION =========================
# ------- Apache2 -------
# fix to uses sockets on fastcgi, which is php-fpm default configuration
VHOST=$(cat <<EOF
<IfModule mod_fastcgi.c>
	AddHandler php5-fcgi .php
	Action php5-fcgi /php5-fcgi
	Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
	FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization
	<Directory /usr/lib/cgi-bin/>
		Options All
		Require all granted
        SetHandler php5-fcgi
	</Directory>
</Ifmodule>
EOF
)

if [ ! -f /etc/apache2/mods-enabled/fastcgi.conf ]; then
	echo "${VHOST}" > /etc/apache2/mods-enabled/fastcgi.conf
fi

# enable apache required modules
sudo a2enmod rewrite actions fastcgi alias


# default conf adds server name
if [ ! -f /etc/apache2/conf-available/default.conf ]; then
	echo "ServerName $domain" > /etc/apache2/conf-available/default.conf
fi
sudo a2enconf default


# ------- PHP5 -------
# install composer
if [ ! -f /usr/local/bin/composer ]; then
	sudo curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
else
	sudo composer self-update
fi


# ------- MySQL -------
# give external access
sed -i 's/bind-address    = 127.0.0.1/bind-address    = 0.0.0.0/g' /etc/mysql/my.cnf;
sed -i 's/skip-external-locking/skip-external-locking \
skip-name-resolve/g' /etc/mysql/my.cnf;


# ==================== FINISH IT =========================
# --- restart services using new config ---
sudo service apache2 restart
sudo service mysql restart
sudo service php5-fpm restart


folder="/var/www"

############## Database ################
# create user and database
mysql -uroot --password="$mysql_root_password" -e "CREATE SCHEMA IF NOT EXISTS $database_name DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -uroot --password="$mysql_root_password" -e "GRANT ALL PRIVILEGES ON $database_name.* TO '$database_user_name'@'localhost' IDENTIFIED BY '$database_user_password' WITH GRANT OPTION;";
mysql -uroot --password="$mysql_root_password" -e "GRANT ALL PRIVILEGES ON $database_name.* TO '$database_user_name'@'%' IDENTIFIED BY '$database_user_password' WITH GRANT OPTION;";


############## APACHE ################
# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain
    ServerAdmin patrick@wideopentech.com

    DocumentRoot $folder
	<Directory $folder>
		AllowOverride All
	</Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > "/etc/apache2/sites-available/$domain.conf"

# server ports
if ! grep -q "Listen 80" /etc/apache2/ports.conf; then
    echo "Listen 80" >> /etc/apache2/ports.conf
fi
if ! grep -q "Listen 80" /etc/apache2/ports.conf; then
    echo "Listen 80" >> /etc/apache2/ports.conf
fi

# update Vagrantfile with the new hosts
if ! grep -q "\"$domain\"" /var/www/Vagrantfile; then
    sudo sed -i -e "s/domains= \[\(.+\)\]/domains= [\1,\"$domain\"]/" /var/www/Vagrantfile
fi

# use the new virtualhost
sudo a2ensite "$domain.conf"
sudo service apache2 reload

# remove the default virtualhost
sudo a2dissite 000-default
sudo service apache2 reload


############## WORDPRESS ################
#istall wordpress
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo rsync -av --exclude='wp-content' wordpress/ $folder

#update wp-config values
sed -i "s/{{db_name}}/$database_name/g" $folder/vagrant/wp-config.php
sed -i "s/{{db_user}}/$database_user_name/g" $folder/vagrant/wp-config.php
sed -i "s/{{db_password}}/$database_user_password/g" $folder/vagrant/wp-config.php

#copy wp-config
sudo rsync -av $folder/vagrant/wp-config.php $folder

#update sql
sed -i "s/{{site_url}}/$domain/g" $folder/vagrant/import.sql

#install seed data
sudo mysql -u"$database_user_name" -p"$database_user_password" "$database_name" < "$folder/vagrant/import.sql"


# == Final Output
echo ''
echo 'All Done!'
echo ''
echo "Now add the ip/domain to your hosts file if you didn't already. A little help:"
echo "echo '' | sudo tee -a /etc/hosts; echo '$ip $domain www.$domain' | sudo tee -a /etc/hosts"
echo ''
echo "Access your new sites http://$domain"
echo ''
echo 'Your WordPress login is:'
echo 'WOTAdmin | D#w*QgZbS%4q0NJysWqjUC46'
echo ''
echo "Your database config is:"
echo "host: $ip"
echo "database: $database_name"
echo "user: $database_user_name"
echo "password: $database_user_password"
echo ''
echo 'You may now enter your new box:'
echo 'vagrant ssh'
echo ''
