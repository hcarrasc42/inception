#!/bin/sh

# Configura el puerto en www.conf
sed -i 's|PHP_PORT|'${PHP_PORT}'|g' /etc/php/7.4/fpm/pool.d/www.conf

# Comprueba si WordPress ya está instalado
if [ -f "/var/www/html/wp-config.php" ]; then
  echo "WordPress ya está instalado en --path=$WP_PATH"
else
  cd /var/www/html
  rm -rf *
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  wp core download --allow-root
  wp config create --allow-root --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --path=$WP_PATH --skip-check
  wp core install --allow-root --path=$WP_PATH --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email
  wp user create hcarrasc hcarrasc@42.fr --allow-root --role=author --path=$WP_PATH --user_pass=hcarrasc
fi

# Inicia PHP-FPM solo si no está en ejecución
if ! pgrep -x "php-fpm7.4" > /dev/null
then
    /usr/sbin/php-fpm7.4 -F
else
    echo "PHP-FPM ya está en ejecución."
fi
