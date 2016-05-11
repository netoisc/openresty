[![Build Status](https://travis-ci.com/3Blades/openresty.svg?token=y3jvxynhJQZHELnDYJdy&branch=master)](https://travis-ci.com/3Blades/openresty)
[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/3blades/openresty)

# openresty
DockerFile to build a basic image based on openresty

## Run the container
    
    docker run -d --name open -p 8090:80 3blades/openresty nginx -p '' -c nginx.conf -g 'daemon off;'

The port 8090 can be changed.
