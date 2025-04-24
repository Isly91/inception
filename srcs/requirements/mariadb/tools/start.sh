#!/bin/bash

# This script is used to initialize a MariaDB database container.
# It sets up the database and user credentials using secrets stored in Docker secrets.
# It also starts the MariaDB service and creates a database and user with the specified privileges.
# The script expects the following environment variables to be set:
# - DB_NAME: The name of the database to be created.
# - DB_ROOT_PASSWORD: The root password for the MariaDB server.
# - DB_PASSWORD: The password for the user to be created.
# - DB_CREDENTIALS: The username for the user to be created.
# The script also expects the following secrets to be available in the Docker secrets directory:
# - db_root_password: The root password for the MariaDB server.
# - db_password: The password for the user to be created.
# - credentials: The username for the user to be created.
# The script starts the MariaDB service, waits for it to be ready, and then creates the database and user with the specified privileges.
# It also stops the MariaDB service before executing the command passed to the script.


SECRETS_PATH=/run/secrets/

echo "🔐 Loading secrets..."
export DB_ROOT_PASSWORD=$(cat ${SECRETS_PATH}db_root_password)
export DB_PASSWORD=$(cat ${SECRETS_PATH}db_password)
export DB_CREDENTIALS=$(cat ${SECRETS_PATH}credentials)

if [ -z "$DB_NAME" ]; then
  echo "DB Name not set"
  exit 1
fi

if [ -z "$DB_ROOT_PASSWORD" ]; then
  echo "DB Root Password not set"
  exit 1
fi

if [ -z "$DB_PASSWORD" ]; then
  echo "DB Password file not set"
  exit 1
fi

if [ -z "$DB_CREDENTIALS" ]; then
  echo "Credentials file not set"
  exit 1
fi

service mariadb start
sleep 5

echo "Creating user and granting privileges"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u root -e "CREATE USER IF NOT EXISTS '$DB_CREDENTIALS'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_CREDENTIALS'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"
echo "Database initialized and user created."

service mariadb stop

exec "$@"
# exec "$@" ensures that the script properly hands over control to CMD ["mysqld_safe"].
# It prevents unnecessary background processes.
# It allows command overriding when running the container.