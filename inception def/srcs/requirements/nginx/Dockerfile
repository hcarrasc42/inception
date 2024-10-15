FROM debian:buster


RUN apt -y update && apt install -y nginx && apt install openssl -y




# COPY ./conf/default /etc/nginx/sites-available/

COPY ./tools/start_nginx.sh /


CMD [ "/start_nginx.sh" ]