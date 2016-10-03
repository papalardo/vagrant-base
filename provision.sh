#!/usr/bin/env bash

echo "-- Creating virtual hosts --"
# Add vhosts
sudo cp -Rv /vagrant/vhosts/* /etc/apache2/sites-available/

avail=/etc/apache2/sites-available/$1.conf
enabled=/etc/apache2/sites-enabled/
site=`ls /vagrant/vhosts/`

if [ "$#" != "1" ]; then
    echo "Available virtual hosts: $site"
    sudo a2ensite $site
else

    if test -e $avail; then
        sudo ln -s $avail $enabled
    else
         "$avail virtual host does not exist! Please create one!$site"
    fi
fi

#rm -rf /var/www/*
#sudo ln -fs /vagrant/www/fields360 /var/www/fields360

echo "Booting the machine..."
sudo service apache2 restart


Update () {
echo "-- Update packages --"
sudo apt-get update
sudo apt-get upgrade
}
#Update

if [ ! -f /var/log/firsttime ];
then
    sudo touch /var/log/firsttime

    # echo "-- Prepare configuration for MySQL --"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

    echo "-- Install tools and helpers --"
    sudo apt-get install -y --force-yes python-software-properties vim htop curl git npm

    echo "-- Install PPA's --"
    sudo add-apt-repository ppa:ondrej/php
    sudo add-apt-repository ppa:chris-lea/redis-server

    echo "-- Install NodeJS --"
    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -

    echo "-- Install packages --"
    sudo apt-get install -y --force-yes apache2 mysql-server-5.6 git-core nodejs rabbitmq-server redis-server
    sudo apt-get install -y --force-yes php7.0-common php7.0-dev php7.0-json php7.0-opcache php7.0-cli libapache2-mod-php7.0 php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-gd php7.0-mcrypt php7.0-mbstring php7.0-bcmath php7.0-zip

    echo "-- Configure PHP &Apache --"
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini
    sudo a2enmod rewrite

    #sudo a2ensite default.conf

    echo "-- Install Composer --"
    curl -s https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod +x /usr/local/bin/composer

    # echo "-- Install phpMyAdmin --"
    # wget -k https://files.phpmyadmin.net/phpMyAdmin/4.0.10.11/phpMyAdmin-4.0.10.11-english.tar.gz
    # sudo tar -xzvf phpMyAdmin-4.0.10.11-english.tar.gz -C /var/www/
    # sudo rm phpMyAdmin-4.0.10.11-english.tar.gz
    # sudo mv /var/www/phpMyAdmin-4.0.10.11-english/ /var/www/phpmyadmin

    # echo "-- Setup databases --"
    mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
    # mysql -uroot -proot -e "CREATE DATABASE my_database";

    Update

    echo "-- Restart Apache --"
    sudo service apache2 restart
fi