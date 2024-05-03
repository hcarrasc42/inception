FROM alpine:3.17

EXPOSE 3306

# All the setup and installation logic
RUN apk update && apk upgrade && apk --no-cache add mariadb mariadb-client mariadb-common && \
    mkdir -p /run/mysqld && mkdir -p /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY /conf/my.cnf /etc/mysql/my.cnf
COPY ./tools/run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

# The command that'll run when the container starts
CMD ["sh", "/tmp/run.sh"]