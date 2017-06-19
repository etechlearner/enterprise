FROM socialengine/nginx-spa:latest

COPY . /app

COPY index.html /app/index.html
