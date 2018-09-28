#!/bin/bash
docker run --rm --name nginx_temp_container -d nginx:latest

rm -rf $PWD/nginx.conf $PWD/conf.d $PWD/default_html $PWD/html 
mkdir conf.d
docker cp nginx_temp_container:/etc/nginx/nginx.conf $PWD/nginx.conf
docker cp nginx_temp_container:/etc/nginx/conf.d $PWD
docker cp nginx_temp_container:/usr/share/nginx/html $PWD
mv html default_html 

docker stop nginx_temp_container

CURRENT_DIR_NAME=`pwd | awk -F "/" '{print $NF}'`

docker run --net=host -d --name $CURRENT_DIR_NAME \
    -v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v $PWD/conf.d:/etc/nginx/conf.d \
    -v $PWD/default_html:/usr/share/nginx/html \
    -v $PWD/container_root:/root \
    nginx:latest
