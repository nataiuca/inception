#!/bin/bash
set -e

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

until mariadb-admin ping -hmariadb --silent; do
	echo "Esperando a MariaDB..."
	sleep 2
done

cd /var/www/html

rm -f /var/www/html/index.nginx-debian.html

if [ ! -f /usr/local/bin/wp ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -f /var/www/html/wp-config.php ]; then
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

	if ! wp user get "$WP_USER" --allow-root > /dev/null 2>&1; then
		wp user create \
			--allow-root \
			"$WP_USER" "$WP_USER_EMAIL" \
			--user_pass="$WP_USER_PASSWORD"
	fi
fi

chown -R www-data:www-data /var/www/html

exec /usr/sbin/php-fpm7.4 -F