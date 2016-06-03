# Dockerfile for OpenResty on Docker Cloud.
# Modify nginx.conf by adding service name for upstream server(s), link
# and add 'Full Access' to Docker Cloud API. Publish internal port to 
# external dynamic port for service discovery.

FROM debian:jessie

MAINTAINER 3Blades <contact@3blades.io>

ENV OPENRESTY_VERSION 1.9.7.5

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -yq --no-install-recommends \
    build-essential \
    git \
    libffi-dev \
    libpq-dev \
    nano \
    python-pip \
    python3-dev \
    python3-pip \
    vim \
    wget \
 && apt-get autoremove \
 && apt-get clean \
 && apt-get autoclean

# Nginx / OpenResty libs
RUN apt-get install -y \
    libreadline-dev \
    libncurses5-dev \
    libpcre3-dev \
    libssl-dev \
    make \
    perl

RUN echo "==> Downloading OpenResty..." \
 && wget -O /tmp/openresty.tar.gz http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz \
 && cd /tmp \
 && tar xzvf openresty.tar.gz \
 && cd /tmp/openresty-$OPENRESTY_VERSION \
 && echo "==> Configuring OpenResty..." \
 && ./configure \
    --with-luajit \
    --with-http_realip_module \
 && echo "==> Building OpenResty..." \
 && make \
 && echo "==> Installing OpenResty..." \
 && make install

RUN mkdir /etc/nginx
RUN mkdir /etc/nginx/logs
ADD nginx.conf /etc/nginx/
WORKDIR /etc/nginx

ENV PATH /usr/local/openresty/nginx/sbin:$PATH

# Define default command.
CMD ["nginx -p '' -c nginx.conf -g 'daemon off;'"]

# Expose ports.
EXPOSE 80
EXPOSE 443