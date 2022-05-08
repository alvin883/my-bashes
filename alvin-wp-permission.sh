#! /bin/bash

WP_ROOT=$1 # <-- wordpress root directory
CURRENT_USER=${USER}
CURRENT_GROUP=$(id -gn)

if [ -z "$1" ]; then
    read -p "Enter wordpress directory: " WP_ROOT
else
    WP_ROOT=$1
fi


if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    echo "MacOs detected, SELinux skipped";
else
    # proper SELinux permission
    # reference: https://wordpress.org/support/topic/unable-to-update-wordpress-4-9-4-to-4-9-6/
    sudo chcon -R -t httpd_sys_rw_content_t ${WP_ROOT}
    echo "done: set SELinux permission"
fi


# reset to safe defaults
sudo find ${WP_ROOT} -exec chown ${CURRENT_USER}:${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT} -type d -exec chmod 755 {} \;
sudo find ${WP_ROOT} -type f -exec chmod 644 {} \;
echo "done: reset safe default"

# allow wordpress to manage wp-config.php (but prevent world access)
sudo chgrp ${CURRENT_GROUP} ${WP_ROOT}/wp-config.php
sudo chmod 660 ${WP_ROOT}/wp-config.php
echo "done: allow wordpress to manage wp-config"

# allow wordpress to manage .htaccess
sudo touch ${WP_ROOT}/.htaccess
sudo chgrp ${CURRENT_GROUP} ${WP_ROOT}/.htaccess
sudo chmod 664 ${WP_ROOT}/.htaccess
echo "done: allow wordpress to manage htaccess"

# allow wordpress to manage wp-content
sudo find ${WP_ROOT}/wp-content -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-content"

sudo find ${WP_ROOT}/wp-admin -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-admin -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-admin -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-admin"

sudo find ${WP_ROOT}/wp-includes -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-includes -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-includes -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-includes"

sudo find ${WP_ROOT}/wp-signup.php -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-signup.php -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-signup.php -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-signup.php"

sudo find ${WP_ROOT}/wp-config-sample.php -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-config-sample.php -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-config-sample.php -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-config-sample.php"

sudo find ${WP_ROOT}/wp-login.php -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-login.php -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-login.php -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-login.php"

sudo find ${WP_ROOT}/wp-settings.php -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-settings.php -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-settings.php -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-settings.php"

sudo find ${WP_ROOT}/wp-load.php -exec chgrp ${CURRENT_GROUP} {} \;
sudo find ${WP_ROOT}/wp-load.php -type d -exec chmod 775 {} \;
sudo find ${WP_ROOT}/wp-load.php -type f -exec chmod 664 {} \;
echo "done: allow wordpress to manage wp-load.php"

# reference: https://unix.stackexchange.com/a/109487
find ${WP_ROOT}/wp-content/themes/ -path "*/node_modules/*" -exec chmod 755 {} \;
echo "done: allow node_modules to be executable to the user, not to wordpress"

echo "completed: alvin-wp-permission.sh"