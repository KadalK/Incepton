#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "[MariaDB] Init database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    echo "[MariaDB] Launching..."
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    PID=$!

    until mariadb-admin ping --silent; do
        sleep 1
    done

    echo "[MariaDB] Config of access and users..."
    mariadb -u root << SQL_EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
FLUSH PRIVILEGES;
SQL_EOF

    kill -s TERM "$PID"
    wait "$PID"
    echo "[MariaDB] Init is up !"
fi

exec mysqld --user=mysql --console
