#! /bin/bash

WP_OWNER=$USER # <-- wordpress owner
WP_GROUP=users # <-- wordpress group
WP_ROOT=$1 # <-- wordpress root directory
WS_GROUP=nginx # <-- webserver group

if [ -z "$1" ]; then
    read -p "Enter wordpress directory: " WP_ROOT
else
    WP_ROOT=$1
fi


# reset to safe defaults
sudo find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
sudo find ${WP_ROOT} -type d -exec chmod 755 {} \;
sudo find ${WP_ROOT} -type f -exec chmod 644 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
sudo chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
sudo chmod 660 ${WP_ROOT}/wp-config.php

# allow wordpress to manage .htaccess
sudo touch ${WP_ROOT}/.htaccess
sudo chgrp ${WS_GROUP} ${WP_ROOT}/.htaccess
sudo chmod 664 ${WP_ROOT}/.htaccess

# allow wordpress to manage wp-content
sudo find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
sudo find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;

echo "completed: alvin-wp-permission.sh"