FROM alpine:3.17

EXPOSE 443

# All the setup and installation logic
RUN apk update && apk upgrade && apk --no-cache add nginx openssl

# Copy configurations and static page
COPY /conf/nginx.conf /etc/nginx/nginx.conf
#COPY /tools/index.html /var/www/html/index.html

# Create ssl keys
RUN openssl req -x509 -days 365 -nodes -newkey rsa:4096 -sha256 \
    -keyout /etc/nginx/openssl.key \
    -out /etc/nginx/openssl.crt \
    -subj "/CN=aarrien.42.fr/"

# The command that'll run when the container starts
CMD ["nginx", "-g", "daemon off;"]