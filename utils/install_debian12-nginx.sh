#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "ClipBucketV5 easy installation script must be run as root"
    exit
fi

clear
echo ""
echo "  ____ _ _       ____             _        _ __     ______"
echo " / ___| (_)_ __ | __ ) _   _  ___| | _____| |\ \   / / ___|"
echo "| |   | | | '_ \|  _ \| | | |/ __| |/ / _ \ __\ \ / /|___ \\"
echo "| |___| | | |_) | |_) | |_| | (__|   <  __/ |_ \ V /  ___) |"
echo " \____|_|_| .__/|____/ \__,_|\___|_|\_\___|\__| \_/  |____/"
echo "          |_|  Installation script for Debian 12 + Nginx"
echo ""
echo "Disclaimer : This easy installation script is only"
echo "             made to configure local / dev environments."
echo "             Use it with caution."
echo ""

echo ""
echo -ne "Updating Debian system..."
apt update > /dev/null 2>&1
apt dist-upgrade -y > /dev/null 2>&1
echo -ne " OK"

echo ""
echo -ne "Installing requiered elements..."
apt install php8.1-fpm apache2 mariadb-server git php8.1-curl ffmpeg php8.1-mysqli php8.1-xml php8.1-mbstring libapache2-mod-php8.1 php8.1-gd sendmail mediainfo --yes > /dev/null 2>&1
echo -ne " OK"

echo ""
echo -ne "Updating PHP php8.1 configs..."
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" /etc/php/8.1/fpm/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 100M/g" /etc/php/8.1/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 7200/g" /etc/php/8.1/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" /etc/php/8.1/cli/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 100M/g" /etc/php/8.1/cli/php.ini
systemctl restart php8.1-fpm
echo -ne " OK"

echo ""
echo -ne "Installing ClipbucketV5 sources..."
mkdir -p /srv/http/clipbucket/ && cd "$_"
git clone https://github.com/MacWarrior/clipbucket-v5.git ./ > /dev/null 2>&1
echo -ne " OK"

echo ""
echo -ne "Updating sources access permissions..."
chown www-data: -R ../clipbucket/
chmod 755 -R ./upload/cache ./upload/files ./upload/images
chmod 755 ./upload/includes
echo -ne " OK"

echo ""
read -p "Which domain name do you want to use ? [clipbucket.local] " READ_DOMAIN
case ${READ_DOMAIN} in
    "")
        DOMAIN_NAME="clipbucket.local"
        ;;
    *)
        DOMAIN_NAME=${READ_DOMAIN}
        ;;
esac

echo ""
echo -ne "Configuring Nginx Vhost..."
rm -f /etc/apache2/sites-enabled/default
cat << 'EOF' > /etc/apache2/sites-available/001-clipbucket.conf DOMAINNAME
<VirtualHost *:80>
  ServerName DOMAINNAME
  DocumentRoot "/srv/http/clipbucket/upload"
  
  AllowEncodedSlashes On
  
  php_value upload_max_filesize 10000M
  php_value post_max_size 10000M
  php_value max_execution_time 7200
  
  <Directory "/srv/http/clipbucket/upload">
    AllowOverride all
    Require all granted
  </Directory>
</VirtualHost>
EOF

sed -i "s/DOMAINNAME/${DOMAIN_NAME}/g" /etc/apache2/sites-available/001-clipbucket.conf
sed -i "s/PHPVERSION/8.1/g" /etc/apache2/sites-available/001-clipbucket.conf
ln -s /etc/apache2/sites-available/001-clipbucket.conf /etc/apache2/sites-enabled/001-clipbucket.conf
sudo a2enmod rewrite
systemctl restart apache2 > /dev/null
echo -ne " OK"

echo ""
echo -ne "Generating DB access..."
mysql -uroot -e "CREATE DATABASE clipbucket;"
DB_PASS=$(date +%s | sha256sum | base64 | head -c 16)
mysql -uroot -e "CREATE USER 'clipbucket'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON clipbucket.* TO 'clipbucket'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -uroot -e "FLUSH PRIVILEGES;"
echo -ne " OK"
echo ""
echo "- Database address : localhost"
echo "- Database name : clipbucket"
echo "- Database user : clipbucket"
echo "- Database password : ${DB_PASS}"
echo "- Website URL : http://${DOMAIN_NAME}"
echo ""
echo "ClipBucketV5 installation completed"
echo ""
