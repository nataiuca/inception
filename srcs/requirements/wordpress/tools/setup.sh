#!/bin/bash
set -e

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

echo "Waiting for MariaDB..."
until mariadb -hmariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" &>/dev/null; do
	sleep 2
done

cd /var/www/html

if [ ! -f /usr/local/bin/wp ]; then
	curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
fi

if [ ! -f wp-config.php ]; then
	wp core download --allow-root

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
		--allow-root
fi

chown -R www-data:www-data /var/www/html

exec php-fpm7.4 -F