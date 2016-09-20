[![Build Status](https://travis-ci.com/3Blades/openresty.svg?token=y3jvxynhJQZHELnDYJdy&branch=master)](https://travis-ci.com/3Blades/openresty)
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/3blades/openresty)

# openresty

DockerFile to build a image based on openresty

## Run the container

```
docker service create \
  --replicas 1 \
  --publish 8080:80 \
  --publish :443 \
  -e PATH="/usr/local/openresty/nginx/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
  -e REDIS_URL="redis://my.redis.endpoint.usw2.cache.amazonaws.com:6379/0" \
  --constraint 'node.labels.type == proxy' \
  --name openresty \
  --network threeblades \
  3blades/openresty:build-64 \
  -p '' -c nginx.conf -g 'daemon off;'
```

Make sure you use a valid endpoint for `REDIS_URL` environment variable. 
    
