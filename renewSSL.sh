#!/bin/bash
#docker-compose up --force-recreate --no-deps certbot
export $(cat .env | xargs)
SSL_PATH="/var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_certbot-etc/_data/live/${DOMAIN}"
cat "${SSL_PATH}/fullchain.pem" "${SSL_PATH}/privkey.pem" > "/etc/haproxy/certs/${DOMAIN}.pem"
service haproxy restart
