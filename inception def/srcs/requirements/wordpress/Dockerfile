FROM debian:buster


RUN apt update -y 

RUN apt install php-fpm php-mysql -y

RUN apt install curl -y


COPY ./tools/start_wordpress.sh /
COPY ./tools/wp-config.php /


CMD [ "/start_wordpress.sh" ]