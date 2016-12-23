[![Build Status](https://travis-ci.com/3Blades/openresty.svg?token=y3jvxynhJQZHELnDYJdy&branch=master)](https://travis-ci.com/3Blades/openresty)
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/3blades/openresty)

# 3Blades Reverse Proxy

## Overview

This repo offers an opinionated [OpenResty](http://openresty.org/en/) setup to work with 3Blades stack.

This configuration depends on upstream app server, notifications server and logspout.

## Run as docker container

```
docker service create \
  --replicas 1 \
  --publish 8080:80 \
  --publish :443 \
  -e PATH="/usr/local/openresty/nginx/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
  -e REDIS_URL="redis://redis:6379/0" \
  --constraint 'node.labels.type == proxy' \
  --name openresty \
  --network threeblades \
  3blades/openresty:build-64 \
  -p '' -c nginx.conf -g 'daemon off;'
```

Notes:

- Make sure you use a valid endpoint for `REDIS_URL` environment variable. 
- `constraint` is optional. This would allow you to launch OpenResty only on dedicated nodes.
- Name can be of your choosing.
- Network name is optional with single host set up (usually done with docker-compose), but necessary for multi host docker setup. Network name can be of your choosing, but would have to be the same network as one launched with upstream servers, otherwise name resolution would not work.
- You could launch this version of OpenResty on hosts (either as docker containers or natively) that point to internal load balancers which in turn balance traffic to internal app server.
- Proxy needs traffic permissions to allow direct connectivity to user server containers.
- You could comment out `ADD nginx.conf /etc/nginx.conf` and run countainer using a volume mount to point to nginx.conf on host with the `docker run -v ...` option.


    
