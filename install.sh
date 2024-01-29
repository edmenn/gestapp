#!/bin/bash
apt install docker
apt install docker-compose

mkdir /var/www/html
cd /var/www/html/
git clone https://bitbucket.org/edmenn/gestapp.git
cp /home/gestapp/installer/.env /var/www/html/gestapp/

chmod 777 -R /var/www/html/gestapp/

cd /var/www/html/gestapp/

docker run --rm -v  $(pwd):/app composer install

cd "$(dirname "$0")"/installer

ls -la

docker-compose up --build -d

docker exec -ti php composer install
docker exec -ti php php artisan migrate
docker exec -ti php php artisan db:seed
docker exec -ti php php artisan key:generate
docker exec -ti php php artisan storage:link


