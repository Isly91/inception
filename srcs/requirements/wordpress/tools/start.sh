#!/bin/bash

SECRETS_PATH="/run/secrets/"

sleep 5

echo "🔐 Loading secrets..."
export DB_ROOT_PASSWORD=$(cat ${SECRETS_PATH}db_root_password)
export DB_PASSWORD=$(cat ${SECRETS_PATH}db_password)
export DB_CREDENTIALS=$(cat ${SECRETS_PATH}credentials)

echo "DB_NAME: $DB_NAME"
echo "DB_pass: $DB_PASSWORD"
echo "credentials: $DB_CREDENTIALS"

export WP_ADMIN=$(cat ${SECRETS_PATH}wp_admin)
export WP_ADMIN_PASS=$(cat ${SECRETS_PATH}wp_admin_pass)
export WP_ADMIN_EMAIL=$(cat ${SECRETS_PATH}wp_admin_email)
export WP_USER=$(cat ${SECRETS_PATH}wp_user)
export WP_USER_PASS=$(cat ${SECRETS_PATH}wp_user_pass)
export WP_USER_EMAIL=$(cat ${SECRETS_PATH}wp_user_email)

if [ -z "$WP_ADMIN" ]; then
    echo "WP_ADMIN not set"
    exit 1
fi

if [ -z "$WP_ADMIN_PASS" ]; then
    echo "WP_ADMIN_PASS not set"
    exit 1
fi

if [ -z "$WP_ADMIN_EMAIL" ]; then
    echo "WP_ADMIN_EMAIL not set"
    exit 1
fi

if [ -z "$WP_USER" ]; then
    echo "WP_USER not set"
    exit 1
fi

if [ -z "$WP_USER_PASS" ]; then
    echo "WP_USER_PASS not set"
    exit 1
fi

if [ -z "$WP_USER_EMAIL" ]; then
    echo "WP_USER_EMAIL not set"
    exit 1
fi

mkdir -p /run/php

echo "dowloading wordpress..."

cd /var/www/html

# creating the database
wp core download --allow-root

wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_CREDENTIALS" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$MARIADB_CONTAINER_NAME" \
    --allow-root

wp core install \
    --url="$DOMAIN_NAME" \
    --title="Inception Site" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root


wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=author \
    --allow-root

echo "Starting PHP-FPM..."
exec "$@"