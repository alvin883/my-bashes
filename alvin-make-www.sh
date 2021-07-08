#! /bin/bash

# check whether the user input domain name or not 
if [ -z "$1" ]; then
    echo -e "\n\n"
    echo "please specify domain name"
    echo "for example:"
    echo "bash alvin-make-www.sh example.com"
    echo -e "\n\n"
    exit 1
else
    echo -e "\n\n"
    echo "folder name: " $1
fi


# make www folder if it doesn't exist
if [ ! -d /var/www/$1 ]; then
    sudo mkdir /var/www/$1
    echo "created /var/www/$1"
fi


# change ownership of the folder into current user, so they can change the code
# without the need of sudo 
sudo chmod -R 755 /var/www/$1
sudo chown -R $USER:$USER /var/www/$1
echo "changed owner of /var/www/$1"


# make nginx server-block configuration file if it doesn't exist
if [[ ! -f /etc/nginx/sites-available/$1.conf ]]; then
    sudo touch /etc/nginx/sites-available/$1.conf
    echo "created /etc/nginx/sites-available/$1.conf"
else 
    echo "server-block configuration already exist"
fi


# write server-block configuration
echo "server {
    listen      80;
    listen      [::]:80;
    server_name test-another.local www.test-another.local;
    root        /var/www/$1;
    location    / {
        try_files \$uri \$uri/ =404;
    }
}" | sudo tee -a /etc/nginx/sites-available/$1.conf > /dev/null


# linked the server-block configuration
if [[ ! -f /etc/nginx/sites-available/$1.conf ]]; then
    sudo ln -s /etc/nginx/sites-available/$1.conf /etc/nginx/sites-enabled/
    echo "linked /etc/nginx/sites-available/$1.conf"
else
    echo "server-block configuration has been linked"
fi


# check if dns already declared in the hosts file or not
if grep -Fxq "127.0.0.1   $1 # generated by alvin-make-www" /etc/hosts
then
    # code if found
    echo "dns already exist in hosts file"
else
    # if not found, add dns to the host file
    echo "127.0.0.1   $1 # generated by alvin-make-www" | sudo tee -a /etc/hosts > /dev/null
    echo "added dns $1 to the hosts file"
fi

# restart Nginx
sudo systemctl restart nginx
echo "done: nginx restarted"


echo "completed"
echo -e "\n\n"