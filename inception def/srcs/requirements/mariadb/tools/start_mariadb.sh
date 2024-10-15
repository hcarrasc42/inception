#!/bin/sh

# Inicialización de la base de datos si no existe
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Base de datos no encontrada. Inicializando..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Iniciamos el servidor MariaDB en segundo plano
    mysqld_safe --skip-networking &

    # Esperamos a que el servidor MariaDB esté disponible
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    # Creación de la base de datos y usuarios
    echo "Creando base de datos y usuarios..."
    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
        GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
EOSQL

    # Detenemos el servidor MariaDB
    mysqladmin shutdown
fi

# Iniciamos el servidor MariaDB en modo normal
exec mysqld_safe