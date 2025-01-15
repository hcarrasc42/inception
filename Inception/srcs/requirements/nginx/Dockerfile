FROM debian:bullseye


RUN apt -y update && apt install -y nginx && apt install openssl -y




# COPY ./conf/default /etc/nginx/sites-available/

COPY ./tools/nginx.sh /


CMD [ "/nginx.sh" ]