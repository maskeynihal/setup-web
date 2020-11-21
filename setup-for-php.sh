#! /bin/bash
USER_ID=$(/usr/bin/id -u)
if [ $USER_ID -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Updating the system
sudo apt update -y && sudo apt upgrade -y

# Installing nginx
sudo apt install nginx -y

# Installing required php

sudo add-apt-repository universe

sudo apt install php-fpm php-mysql php-gd php-mbstring php-xml php-bcmath php-zip -y

# Installing composer

EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php
sudo mv ./composer.phar /usr/local/bin/composer

