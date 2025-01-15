#!/bin/bash

# Crear directorios para certificados SSL si no existen
mkdir -p /etc/ssl/private /etc/ssl/certs

# Generar un certificado autofirmado para SSL/TLS
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
-subj "/C=MO/L=KH/O=1337/OU=student/CN=hcarrasc.42.fr"

# Asegurar permisos correctos para el directorio raíz
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Crear archivo de configuración para redirigir HTTP a HTTPS
echo "
server {
    listen 80;
    listen [::]:80;
    server_name hcarrasc.42.fr www.hcarrasc.42.fr;

    # Redirección permanente de HTTP a HTTPS
    return 301 https://\$host\$request_uri;
}
" > /etc/nginx/sites-available/http_redirect

# Crear archivo de configuración para HTTPS en el puerto 443
echo "
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name hcarrasc.42.fr www.hcarrasc.42.fr;

    # Configuración del certificado SSL
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    # Configuración del directorio raíz y archivo de índice
    root /var/www/html;
    index index.php index.html;

    # Configuración para manejar archivos PHP con php-fpm
    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_pass wordpress:9000;  # Contenedor de WordPress
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    # Manejar archivos estáticos
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
}
" > /etc/nginx/sites-available/default

# Enlazar las configuraciones para que NGINX las use
ln -sf /etc/nginx/sites-available/http_redirect /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Arrancar NGINX en primer plano
nginx -g "daemon off;"
