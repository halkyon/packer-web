#!/bin/bash -ex

# Enable mod-rewrite in Apache
a2enmod rewrite
a2enmod php5

# Disable default site (Apache 2.2)
if [ -f /etc/apache2/sites-enabled/default ]; then
	a2dissite default
fi
# Disable default site (Apache 2.4)
if [ -f /etc/apache2/sites-enabled/000-default.conf ]; then
	a2dissite 000-default.conf
fi

mv /var/tmp/silverstripe-vhost /etc/apache2/sites-available/silverstripe.conf
mv /var/tmp/_ss_environment.php /var/_ss_environment.php
a2ensite silverstripe.conf

# Restart Apache
service apache2 restart

# Create webroot
rm -rf /var/www
mkdir /var/www
composer create-project silverstripe/installer /var/www \
	--no-dev --prefer-dist --no-progress

# Install a task for generating lots of pages in SilverStripe
mkdir -p /var/www/mysite/code/tasks
sudo mv /var/tmp/GeneratePagesTask.php /var/www/mysite/code/tasks/GeneratePagesTask.php

# Install extra scripts for checking PHP information
echo -e "<?php\nphpinfo();" > /var/www/phpinfo.php
mv /var/tmp/opcache.php /var/www/opcache.php
mv /var/tmp/apc.php /var/www/apc.php

# Fix webroot permissions
chown -R www-data:www-data /var/www
chmod -R 0755 /var/www

# Ensure database is built
sudo -u www-data php /var/www/framework/cli-script.php dev/build flush=1
sudo -u www-data php /var/www/framework/cli-script.php dev/tasks/GeneratePagesTask
