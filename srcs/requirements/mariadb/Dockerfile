FROM    debian:bullseye

RUN     apt-get update -y && apt-get upgrade -y && apt-get install mariadb-server mariadb-client -y && \
        mkdir -p /var/run/mysqld && \
        chown -R mysql:mysql /var/run/mysqld && chown -R mysql:mysql /etc/mysql/

COPY    ./tools/mariadb.sh /tmp/
COPY    ./conf/init.sql /tmp/
COPY    ./conf/my.cnf /etc/mysql

RUN     chown -R mysql:mysql /tmp/ && \
        chown -R mysql:mysql /etc/mysql

USER    mysql

ENTRYPOINT ["sh", "/tmp/mariadb.sh"]