FROM debian:buster

RUN apt-get update
RUN apt-get install -y nginx openssl

EXPOSE 443

COPY ./conf/default /etc/nginx/sites-enabled/default
COPY ./tools/nginx.sh /var/www

RUN chmod +x /var/www/nginx.sh

ENTRYPOINT [ "var/www/nginx.sh" ]

CMD ["nginx", "-g", "daemon off;"]