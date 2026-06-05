#!/bin/bash
set -e

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

echo "Waiting for MariaDB..."

until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
	sleep 2
done

echo "MariaDB started!"

cd /var/www/html

if [ ! -f /usr/local/bin/wp ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -f wp-config.php ]; then
	wp core download --allow-root --force

	wp config create \
		--allow-root \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="mariadb:3306"

	wp core install \
		--allow-root \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL"

	wp user create \
		"$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--allow-root || true
fi

chown -R www-data:www-data /var/www/html

exec /usr/sbin/php-fpm8.2 -F
