#!/bin/bash

# Проверяем, слушает ли веб-сервер порт 80
if ! nc -z localhost 80; then
    echo "Web server is not running on port 80"
    exit 1
fi

# Проверяем наличие index.html
if [ ! -f "/var/www/html/index.nginx-debian.html" ]; then
    echo "index.html not found in /var/www/html/"
    exit 1
fi

# Если всё в порядке
exit 0
