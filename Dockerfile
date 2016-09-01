# Dockerfile for OpenResty on Docker Cloud.
# Modify nginx.conf by adding service name for upstream server(s), link
# and add 'Full Access' to Docker Cloud API. Publish internal port to 
# external dynamic port for service discovery.

FROM debian:jessie

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

# Nginx / OpenResty libs
RUN apt-get install -y \
    libreadline-dev \
    libncurses5-dev \
    libpcre3-dev \
    libssl-dev \
    make \
    perl

ENV OPENRESTY_VERSION 1.11.2.1

RUN echo "==> Downloading OpenResty..." \
 && wget -O /tmp/openresty.tar.gz http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz \
 && cd /tmp \
 && tar xzvf openresty.tar.gz \
 && cd /tmp/openresty-$OPENRESTY_VERSION \
 && echo "==> Configuring OpenResty..." \
 && ./configure \
    --with-luajit \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_realip_module \
 && echo "==> Building OpenResty..." \
 && make -j$(nproc) \
 && echo "==> Installing OpenResty..." \
 && make install

RUN mkdir /etc/nginx
RUN mkdir /etc/nginx/logs
RUN mkdir /logs
RUN touch /logs/error.log
RUN mkdir /client_body_temp
RUN touch /etc/nginx/logs/flask-error.log
RUN touch /etc/nginx/logs/flask-access.log

ENV PATH=/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:$PATH

WORKDIR /etc/nginx
# Define default command.
CMD ["/usr/local/openresty/nginx/sbin/nginx -p '' -c nginx.conf -g 'daemon off;'"]

# Expose ports.
EXPOSE 80
EXPOSE 443
ADD server.lua /etc/nginx/
ADD container.lua /etc/nginx/
ADD nginx.conf /etc/nginx/