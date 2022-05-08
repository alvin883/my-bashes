#! /bin/bash

MY_HOSTNAME=""
FULL_PATH=$(realpath $0)
DIR_PATH=$(dirname ${FULL_PATH})
WWW_PATH=$(grep WWW_PATH ${DIR_PATH}/.env | cut -d '=' -f 2-)
NGINX_PATH=$(grep NGINX_PATH ${DIR_PATH}/.env | cut -d '=' -f 2-)
PHP_FPM=$(grep PHP_FPM ${DIR_PATH}/.env | cut -d '=' -f 2-)


# check whether the user input domain name or not 
if [ -z "$1" ]; then
    echo -e "\n"
    read -p "Enter the hostname (without .local): " MY_HOSTNAME
else
    echo -e "\n"
    MY_HOSTNAME=$1
    echo "Enter the hostname: " ${MY_HOSTNAME}
fi


# auto add .local to the hostname
MY_HOSTNAME=${MY_HOSTNAME}\.local


# make www folder if it doesn't exist
if [ ! -d ${WWW_PATH}/${MY_HOSTNAME} ]; then
    sudo mkdir ${WWW_PATH}/${MY_HOSTNAME}
    echo "created ${WWW_PATH}/${MY_HOSTNAME}"
fi


# change ownership of the folder into current user, so they can change the code
# without the need of sudo 
sudo chmod -R 755 ${WWW_PATH}/${MY_HOSTNAME}
sudo chown -R $USER:$USER ${WWW_PATH}/${MY_HOSTNAME}
echo "done: change owner of ${WWW_PATH}/${MY_HOSTNAME}"


# make nginx server-block configuration file if it doesn't exist
if [[ ! -f ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf ]]; then
    sudo touch ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf
    echo "done: create ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf"
else 
    echo "FAILED: create ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf"
    echo "------- server-block configuration already exist"
fi


# write server-block configuration
echo "server {
    listen      80;
    listen      [::]:80;
    server_name ${MY_HOSTNAME} www.${MY_HOSTNAME};
    root        ${WWW_PATH}/${MY_HOSTNAME};

    location    / {
        try_files \$uri \$uri/ /index.php?$args =404;
    }

    location ~ \.php\$ {
        fastcgi_pass    ${PHP_FPM};
        fastcgi_param   SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_index   index.php;
        include         fastcgi_params;
    }
}" | sudo tee -a ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf > /dev/null
echo "done: setup ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf"


# linked the server-block configuration
if [[ ! -f ${NGINX_PATH}/sites-enabled/${MY_HOSTNAME}.conf ]]; then
    sudo ln -s ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf ${NGINX_PATH}/sites-enabled/
    echo "done: link sites-enabled for ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf"
else
    echo "FAILED: link sites-enabled for ${NGINX_PATH}/sites-available/${MY_HOSTNAME}.conf"
    echo "------- server-block configuration has been linked"
fi


# check if dns already declared in the hosts file or not
if grep -Fxq "127.0.0.1   ${MY_HOSTNAME} # generated by alvin-make-www" /etc/hosts
then
    # code if found
    echo "FAILED: added dns ${MY_HOSTNAME} to the hosts file"
    echo "------- dns already exist in hosts file"
else
    # if not found, add dns to the host file
    echo "127.0.0.1   ${MY_HOSTNAME} # generated by alvin-make-www" | sudo tee -a /etc/hosts > /dev/null
    echo "done: add dns ${MY_HOSTNAME} to the hosts file"
fi

# restart Nginx
sudo systemctl restart nginx
echo "done: nginx restarted"


echo "hostname: ${MY_HOSTNAME}"
echo "completed: alvin-make-www.sh"