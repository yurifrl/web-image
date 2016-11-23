FROM nginx:alpine
MAINTAINER Yuri Freire <yurifrl@outlook.com>

# Install nginx
RUN apk add --update --no-cache nodejs curl git

# PHANTONJS
RUN curl -LsS https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz | tar -xz -C /

# Add for nginx
RUN addgroup -S nginx \
  && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx

# Prerender
RUN git clone https://github.com/prerender/prerender.git
WORKDIR /prerender
RUN npm install

RUN apk del curl git

# Set the compiled app as workdir
WORKDIR /app

# Add start script
COPY ./config/start /start
RUN chmod +x /start

# Set nginx config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY ./config/app.conf /etc/nginx/conf.d/app.conf

# Add the ssl certificates
ONBUILD COPY ./certs/ /certs

# Move the compiled folder
ONBUILD COPY ./dist/ /app/

EXPOSE 80 443

VOLUME ["/app/node_modules", "/app/bower_components"]

# Start nginx
CMD ["/bin/sh", "/start"]

