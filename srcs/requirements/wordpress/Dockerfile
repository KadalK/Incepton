FROM debian:12.4

RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Create web's dir and define perm
RUN mkdir -p /var/www/wordpress /run/php && \
    chown -R www-data:www-data /var/www/wordpress

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh

RUN chmod +x /usr/local/bin/auto_config.sh

EXPOSE 9000

CMD ["rm wp-config.php"]

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]
