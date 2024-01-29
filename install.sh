#!/bin/bash

# Verificar si Docker está instalado
if ! command -v docker &>/dev/null; then
    apt install docker
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &>/dev/null; then
    apt install docker-compose
fi

# Directorio de trabajo
working_dir="/var/www/html"
app_dir="${working_dir}/gestapp"
installer_dir="/home/gestapp/installer"

# Crear directorio si no existe
mkdir -p "${working_dir}"

# Clonar el repositorio
cd "${working_dir}"
git clone https://bitbucket.org/edmenn/gestapp.git

# Copiar el archivo .env
cp "${installer_dir}/.env" "${app_dir}"

# Cambiar permisos adecuados (ajusta según tus necesidades)
chmod -R 755 "${app_dir}"

# Ejecutar Composer en un contenedor Docker
docker run --rm -v "$(pwd):/app" composer install

# Cambiar al directorio del instalador
cd "${installer_dir}"

# Iniciar Docker Compose
docker-compose up --build -d

# Definir función para ejecutar comandos de Docker
docker_exec() {
    docker exec -ti php "$@"
}

# Instalar dependencias en el contenedor de PHP
docker_exec composer install

# Ejecutar migraciones y otros comandos de Artisan
docker_exec php artisan migrate
docker_exec php artisan db:seed
docker_exec php artisan key:generate
docker_exec php artisan storage:link
