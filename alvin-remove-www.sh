#! /usr/bin/env bash

MY_HOSTNAME=""

# check whether the user input MY_HOSTNAME or not 
if [ -z "$1" ]; then
    echo -e "\n"
    read -p "Enter the hostname (without .local): " MY_HOSTNAME
else
    echo -e "\n"
    MY_HOSTNAME=$1
    echo "Enter the hostname (without .local): " ${MY_HOSTNAME}
fi

# auto add .local to the hostname
MY_HOSTNAME=${MY_HOSTNAME}\.local

# delete www folder
sudo rm -r /var/www/${MY_HOSTNAME}
echo "done: deleted /var/www/${MY_HOSTNAME} folder"

# delete nginx server-block config
sudo rm /etc/nginx/sites-enabled/${MY_HOSTNAME}.conf
sudo rm /etc/nginx/sites-available/${MY_HOSTNAME}.conf
echo "done: deleted /etc/nginx/sites-available/${MY_HOSTNAME}.conf"

# delete dns line from the hosts file
sudo sed -i "/${MY_HOSTNAME}/d" /etc/hosts

# restart Nginx
sudo systemctl restart nginx
echo "done: nginx restarted"


echo "completed: alvin-remove-www.sh"