#!/bin/bash
apt install docker 
apt install docker-compose

git clone https://bitbucket.org/edmenn/gestapp.git
mkdir /var/www/
mkdir /var/www/html
mv gestapp/* /var/www/html
cp installer/.env /var/www/html/
mv * /var/www/html/

chmod 777 -R /var/www/html/

cd /var/www/html/

docker run --rm -v  $(pwd):/app composer install


cd /var/www/html/installer/

ls -la

docker-compose up --build -d

docker exec -ti php composer install
docker exec -ti php php artisan migrate
docker exec -ti php php artisan db:seed
docker exec -ti php php artisan key:generate
docker exec -ti php php artisan storage:link
docker exec -ti php php -S localhost:8000 server.php 


