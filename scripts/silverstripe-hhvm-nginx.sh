#!/bin/bash -ex

# Disable default site and enable silverstripe site
rm /etc/nginx/sites-enabled/default
mv /var/tmp/nginx-hhvm.conf /etc/nginx/hhvm.conf
mv /var/tmp/nginx-silverstripe.conf /etc/nginx/silverstripe.conf
mv /var/tmp/silverstripe-vhost /etc/nginx/sites-available/silverstripe
mv /var/tmp/_ss_environment.php /var/_ss_environment.php
ln -s /etc/nginx/sites-available/silverstripe /etc/nginx/sites-enabled/silverstripe

# Restart nginx
service nginx restart

# Create webroot with correct permissions
rm -rf /var/www
mkdir /var/www
hhvm -v ResourceLimit.SocketDefaultTimeout=600 -v Http.SlowQueryThreshold=600000 -v Eval.Jit=false \
	/usr/local/bin/composer create-project silverstripe/installer /var/www \
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