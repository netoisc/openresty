# Dockerfile for OpenResty on Docker Cloud.
# Modify nginx.conf by adding service name for upstream server(s), link
# and add 'Full Access' to Docker Cloud API. Publish internal port to 
# external dynamic port for service discovery.

FROM ubuntu:16.04
MAINTAINER 3Blades <contact@3blades.io>

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

# Nginx / OpenResty
RUN apt-get install -y \
    libreadline-dev \
    libncurses5-dev \
    libpcre3-dev \
    libssl-dev \
    make \
    perl

RUN wget -O /tmp/openresty.tar.gz http://openresty.org/download/ngx_openresty-1.9.7.5.tar.gz \
 && cd /tmp \
 && tar xzvf openresty.tar.gz \
 && cd /tmp/openresty-1.9.7.5 \
 && ./configure --with-luajit --with-http_realip_module \
 && make \
 && make install

RUN mkdir /etc/nginx
RUN mkdir /etc/nginx/logs
ADD nginx.conf /etc/nginx/
ADD model.lua /etc/nginx/
WORKDIR /etc/nginx

ENV PATH /usr/local/openresty/nginx/sbin:$PATH

# Define default command.
CMD ["nginx -p '' -c nginx.conf -g 'daemon off;'"]

# Expose ports.
EXPOSE 80
EXPOSE 443
