#!/bin/bash
# Clipbucket install on Debian 12
## THIS SCRIPT MUST BE LAUNCHED AS ROOT

echo ""
echo -ne "Updating Debian system..."
apt update > /dev/null 2>&1
apt dist-upgrade -y > /dev/null 2>&1
echo -ne " OK"

echo ""
echo -ne "Installing requiered elements..."
apt install php8.2-fpm apache2 libapache2-mod-php mariadb-server git php8.2-curl ffmpeg php8.2-mysqli php8.2-xml php8.2-mbstring php8.2-gd sendmail mediainfo --yes
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" /etc/php/8.2/fpm/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 100M/g" /etc/php/8.2/fpm/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 7200/g" /etc/php/8.2/fpm/php.ini
systemctl restart php8.2-fpm
echo -ne " OK"

echo ""
echo -ne "Installing Clipbucket sources..."
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

echo ""
echo -ne "Configuring Nginx Vhost..."
cat << 'EOF' > /etc/apache2/sites-available/001-clipbucket
<VirtualHost *:80>
  ServerName egirlpornos.com
  DocumentRoot "/srv/http/clipbucket/clipbucket-v5/upload"
  
  AllowEncodedSlashes On
  
  <Directory "/srv/http/clipbucket/clipbucket-v5/upload">
    AllowOverride all
    Require all granted
  </Directory>
</VirtualHost>
EOF

ln -s /etc/nginx/sites-available/001-clipbucket /etc/nginx/sites-enabled/

# Restarting Apache service
systemctl restart nginx > /dev/null

echo -ne " OK"
echo ""
echo "- Website URL : http://clipbucket.local"

echo ""
echo "Clipbucket installation completed"
echo ""
