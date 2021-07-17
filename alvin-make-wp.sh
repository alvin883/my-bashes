#! /usr/bin/env bash

MY_HOSTNAME=""

# get WORDPRESS_SOURCE_PATH from .env file
# $0 is the path of the current executed scripts
FULL_PATH=$(realpath $0)
DIR_PATH=$(dirname ${FULL_PATH})
WORDPRESS_SOURCE_PATH=$(grep WORDPRESS_SOURCE_PATH ${DIR_PATH}/alvin-make-wp.env | cut -d '=' -f 2-)


# check whether the user input MY_HOSTNAME or not 
if [ -z "$1" ]; then
    echo -e "\n"
    read -p "Enter the hostname (without .local): " MY_HOSTNAME
else
    echo -e "\n"
    MY_HOSTNAME=$1
    echo "Enter the hostname: " ${MY_HOSTNAME}
fi


# auto add .local to the hostname
MY_DB_NAME=${MY_HOSTNAME}
MY_RAW_HOSTNAME=${MY_HOSTNAME}
MY_HOSTNAME=${MY_HOSTNAME}\.local
echo "Database name: ${MY_DB_NAME}"
echo "Wordpress source path: $WORDPRESS_SOURCE_PATH"


read -s -p "Database root password: " MY_DB_ROOT_PASS


echo -e "\n"
echo "running ..."


# make www
echo "run alvin-make-wp.sh ..."
alvin-make-www.sh ${MY_RAW_HOSTNAME}
echo -e "\n\n"
echo "run wordpress related setup ..."

# copy wordpress files
sudo cp -r ${WORDPRESS_SOURCE_PATH} /var/www/${MY_HOSTNAME}
echo "done: copy wordpress files"

# copy wp-config.php
sudo cp /home/alvin/Documents/my-bashes/alvin-make-wp.wp-config.php /var/www/${MY_HOSTNAME}/wp-config.php
echo "done: copy wp-config.php"

# change the directory to a correct WP files permission
echo "run alvin-wp-permission.sh ..."
alvin-wp-permission.sh /var/www/${MY_HOSTNAME}
echo "done: change correct permission"

# rename all the config in wp-config.php
sudo sed -i "s/CLI_DATABASE_NAME/${MY_DB_NAME}/g" /var/www/${MY_HOSTNAME}/wp-config.php
sudo sed -i "s/CLI_DATABASE_USER/root/g" /var/www/${MY_HOSTNAME}/wp-config.php
sudo sed -i "s/CLI_DATABASE_PASSWORD/${MY_DB_ROOT_PASS}/g" /var/www/${MY_HOSTNAME}/wp-config.php
echo "done: setup wp-config.php file"

# symlink phpMyAdmin
sudo ln -s /usr/share/phpMyAdmin /var/www/${MY_HOSTNAME}/phpmyadmin
echo "done: symlink phpmyadmin"

# create empty database
sudo mysql -u root -e "create database \`$MY_DB_NAME\`"
echo "done: create database"

echo "wordpress site: ${MY_HOSTNAME}"
echo -e "completed: alvin-make-wp.sh"