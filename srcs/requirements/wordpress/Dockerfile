FROM debian:bookworm

RUN apt-get update && apt-get install -y \
		php8.2 \
		php8.2-fpm \
		php8.2-mysql \
		mariadb-client \
		curl \
	 && rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh
RUN mkdir -p /run/php

EXPOSE 9000

CMD ["/setup.sh"]
