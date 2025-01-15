## DOCKERFILE FILE ##

FROM	debian:bullseye

RUN     apt update -y && \
        apt-get upgrade -y && \
        apt-get install -y php7.4 \
        php7.4-mysql \
        php7.4-cli \
        php7.4-mbstring \
        php7.4-fpm \
        php7.4-gettext \
        mariadb-client \
        wget

RUN	rm -rf /etc/php/7.4/fpm/pool.d/www.conf

RUN	mkdir -p /run/php

COPY    ./conf/www.conf /etc/php/7.4/fpm/pool.d/

COPY    ./tools/wordpress.sh /tmp/

RUN     chmod +x /tmp/wordpress.sh

ENTRYPOINT [ "sh", "/tmp/wordpress.sh" ]