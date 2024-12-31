#!/bin/bash

set -e
LOG="install.log"

echo "Installation started: $(date)" | tee -a "$LOG"

sudo apt update -y | tee -a "$LOG"

sudo apt install software-properties-common curl git -y | tee -a "$LOG"

sudo add-apt-repository ppa:ondrej/php -y | tee -a "$LOG"

sudo apt update -y | tee -a "$LOG"

sudo apt install -y php8.1 php8.1-fpm php8.1-cli php8.1-common php8.1-mysql \
php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath \
php8.1-mcrypt php8.1-memcache php8.1-imagick php8.1-imap php8.1-pgsql \
php8.1-opcache php8.1-memcached php8.1-bz2 php8.1-soap | tee -a "$LOG"

PHP_FPM_INI="/etc/php/8.1/fpm/php.ini"

sudo sed -i \
    -e 's/^upload_max_filesize =.*/upload_max_filesize = 100M/' \
    -e 's/^post_max_size =.*/post_max_size = 100M/' \
    -e 's/^max_execution_time =.*/max_execution_time = 1200/' \
    -e 's/^max_input_vars =.*/max_input_vars = 3000/' \
    -e 's/^max_input_time =.*/max_input_time = 1000/' \
    "$PHP_FPM_INI" | tee -a "$LOG"

PHP_CLI_INI="/etc/php/8.1/cli/php.ini"

sudo sed -i \
    -e 's/^upload_max_filesize =.*/upload_max_filesize = 100M/' \
    -e 's/^post_max_size =.*/post_max_size = 100M/' \
    -e 's/^max_execution_time =.*/max_execution_time = 1200/' \
    -e 's/^max_input_vars =.*/max_input_vars = 3000/' \
    -e 's/^max_input_time =.*/max_input_time = 1000/' \
    "$PHP_CLI_INI" | tee -a "$LOG"



sudo apt install nginx mysql-server -y | tee -a "$LOG"

sudo systemctl start nginx mysql | tee -a "$LOG"

sudo systemctl enable nginx mysql | tee -a "$LOG"

NGINX_CONF="/etc/nginx/sites-available/default"

sudo tee "$NGINX_CONF" > /dev/null <<EOF

server {
    listen 80;
    server_name localhost;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}

EOF


sudo nginx -t | tee -a "$LOG"

sudo systemctl restart nginx | tee -a "$LOG"

sudo curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php | tee -a "$LOG"

HASH=$(curl -sS https://composer.github.io/installer.sig) | tee -a "$LOG"

sudo php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink ('/tmp/composer-setup.php'); exit(1); } echo PHP_EOL;" | tee -a "$LOG"

sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer | tee -a "$LOG"


sudo apt install composer -y | tee -a "$LOG"

composer --version | tee -a "$LOG"

curl -sL https://deb.nodesource.com/setup_20.x | sudo bash - | tee -a "$LOG"

sudo apt install nodejs -y | tee -a "$LOG"

node -v | tee -a "$LOG"

npm -v | tee -a "$LOG"

sudo add-apt-repository ppa:deadsnakes/ppa -y | tee -a "$LOG"

sudo apt update -y | tee -a "$LOG"

sudo apt install python3.8 python3.8-distutils python3-pip -y | tee -a "$LOG"

python3.8 --version | tee -a "$LOG"

sudo apt install openjdk-17-jdk -y | tee -a "$LOG"

java -version | tee -a "$LOG"

sudo tee /var/www/html/index.php > /dev/null <<EOF
<?php
\$phpVersion = phpversion();
\$pythonVersion = shell_exec('python3 --version');
\$nodeVersion = shell_exec('node -v');

\$npmVersion = shell_exec('npm -v');
\$composerVersion = shell_exec('composer --version');
\$mysqlVersion = shell_exec('mysql --version');
\$javaVersion = shell_exec('java -version 2>&1 | head -n 1');

echo "<html><head><title>System Information</title></head><body>";
echo "<h1>System Information</h1>";
echo "<table border='1' cellpadding='5'>";

echo "<tr><th>Software</th><th>Version</th></tr>";
echo "<tr><td>PHP Version</td><td>\$phpVersion</td></tr>";

echo "<tr><td>Python Version</td><td>\$pythonVersion</td></tr>";
echo "<tr><td>Node.js Version</td><td>\$nodeVersion</td></tr>";

echo "<tr><td>NPM Version</td><td>\$npmVersion</td></tr>";
echo "<tr><td>Composer Version</td><td>\$composerVersion</td></tr>";
echo "<tr><td>Java Version</td><td>\$javaVersion</td></tr>";
echo "<tr><td>MySQL Version</td><td>\$mysqlVersion</td></tr>";
echo "</table>";
echo "</body></html>";
?>
EOF

echo "Installated successfully: $(date)" | tee -a "$LOG"

