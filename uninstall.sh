#!/bin/bash
docker stop $(docker ps -aq)
docker system prune -a -f
rm -rf /var/www/html/*
 