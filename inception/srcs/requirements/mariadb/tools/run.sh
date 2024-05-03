#!/bin/sh

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

tfile=`mktemp`
if [ ! -f "$tfile" ]; then
	return 1
fi

cat << EOF > $tfile

USE mysql ;
FLUSH PRIVILEGES ;

GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
FLUSH PRIVILEGES ;

CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost';
FLUSH PRIVILEGES ;

EOF

/usr/bin/mysqld --user=mysql --bootstrap < $tfile

exec /usr/bin/mysqld --user=mysql --console