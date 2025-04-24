# It is used to create a Docker image for the MariaDB database server.
# The image is based on the official Debian Bullseye image and installs the MariaDB server.

# Use the official Debian Bullseye image as the base image
FROM debian:bullseye

# Update the package list, install MariaDB server, clean up, and remove unnecessary files
RUN apt-get update && apt-get install -y mariadb-server && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the custom start script into the container
COPY tools/start.sh /start.sh

# Copy the custom MariaDB configuration file into the container with default name
COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

# Make the start script executable
RUN chmod +x /start.sh

# Expose port 3306 for MariaDB connections
EXPOSE 3306

# Set the start script as the entry point for the container
ENTRYPOINT ["/start.sh"]

# Default command to run the MariaDB server in safe mode
CMD ["mysqld_safe"]



