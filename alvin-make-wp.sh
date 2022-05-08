#! /usr/bin/env bash


MY_HOSTNAME=""
OPTIONS_NO_CREATE_DB=false

# get WORDPRESS_SOURCE_PATH from .env file
# $0 is the path of the current executed scripts
FULL_PATH=$(realpath $0)
DIR_PATH=$(dirname ${FULL_PATH})
CURRENT_DIR=$PWD
WORDPRESS_SOURCE_PATH=$(grep WORDPRESS_SOURCE_PATH ${DIR_PATH}/.env | cut -d '=' -f 2-)
NGINX_PATH=$(grep NGINX_PATH ${DIR_PATH}/.env | cut -d '=' -f 2-)
WWW_PATH=$(grep WWW_PATH ${DIR_PATH}/.env | cut -d '=' -f 2-)
PHPMYADMIN_PATH=$(grep PHPMYADMIN_PATH ${DIR_PATH}/.env | cut -d '=' -f 2-)


Help() {
    echo ""
    echo "--------------------------------------------------------------------------------"
    echo "Available options:"
    echo "--no-create-database"
    echo "--hostname            : to specify the hostname in one line (without .local)"
    echo "--------------------------------------------------------------------------------"
    echo ""
}


# get options
while [[ $# -gt 0 ]]; do
    case "$1" in
    --hostname)
        MY_HOSTNAME=$2
        shift
        ;;
    --no-create-database)
        OPTIONS_NO_CREATE_DB=true
        shift
        ;;
    --help)
        Help
        exit
        ;;
    *)
        shift
        ;;
    esac
done


# check if hostname is already filled or not
hostname_length=$(expr length "$MY_HOSTNAME")
if [ $hostname_length -gt 0 ] ; then
    # hostname has been filled
    echo -e "\n"
    echo "Enter the hostname (without .local): " ${MY_HOSTNAME}
else
    # hostname is empty
    echo -e "\n"
    read -p "Enter the hostname (without .local): " MY_HOSTNAME
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
echo "run alvin-make-www.sh ..."
alvin-make-www.sh ${MY_RAW_HOSTNAME}
echo -e "\n\n"
echo "run wordpress related setup ..."

# copy wordpress files
sudo cp -r "${WORDPRESS_SOURCE_PATH}/*" ${WWW_PATH}/${MY_HOSTNAME}
echo "done: copy wordpress files"

# copy wp-config.php
sudo cp ${CURRENT_DIR}/alvin-make-wp.wp-config.php ${WWW_PATH}/${MY_HOSTNAME}/wp-config.php
echo "done: copy wp-config.php"

# change the directory to a correct WP files permission
echo "run alvin-wp-permission.sh ..."
alvin-wp-permission.sh ${WWW_PATH}/${MY_HOSTNAME}
echo "done: change correct permission"

# rename all the config in wp-config.php
sudo sed -i "s/CLI_DATABASE_NAME/${MY_DB_NAME}/g" ${WWW_PATH}/${MY_HOSTNAME}/wp-config.php
sudo sed -i "s/CLI_DATABASE_USER/root/g" ${WWW_PATH}/${MY_HOSTNAME}/wp-config.php
sudo sed -i "s/CLI_DATABASE_PASSWORD/${MY_DB_ROOT_PASS}/g" ${WWW_PATH}/${MY_HOSTNAME}/wp-config.php
echo "done: setup wp-config.php file"

# symlink phpMyAdmin
sudo ln -s ${PHPMYADMIN_PATH} ${WWW_PATH}/${MY_HOSTNAME}/phpmyadmin
echo "done: symlink phpmyadmin"

# create empty database
if [ "$OPTIONS_NO_CREATE_DB" = false ] ; then
    sudo mysql -u root -e "create database \`$MY_DB_NAME\`"
    echo "done: create database"
fi

echo "wordpress site: ${MY_HOSTNAME}"
echo -e "completed: alvin-make-wp.sh"