# Use the official Debian Bullseye base image
FROM debian:bullseye

# Update package lists and install required dependencies
RUN apt-get update && apt-get install -y \
    mariadb-client \ # MariaDB client for database interaction
    lsb-release \ # Tool to get Linux Standard Base information
    ca-certificates \ # Certificates for HTTPS communication
    apt-transport-https \ # Allows the use of HTTPS in apt
    software-properties-common \ # Manage software repositories
    curl \ # Command-line tool for transferring data
    gnupg2 \ # GNU Privacy Guard for secure communication
    && echo "Adding PHP repository" \ # Log message
    && curl -sSL https://packages.sury.org/php/README.txt | bash - \ # Add PHP repository
    && apt-get update && apt-get install -y \ # Update and install PHP packages
    php8.1-fpm \ # PHP FastCGI Process Manager
    php8.1-mysql \ # PHP MySQL extension
    php8.1-mbstring \ # PHP multibyte string extension
    php8.1-xml \ # PHP XML extension
    php8.1-curl \ # PHP cURL extension
    php8.1-zip \ # PHP ZIP extension
    php8.1-gd \ # PHP GD library for image processing
    php8.1-bcmath \ # PHP arbitrary precision math extension
    && apt-get clean && rm -rf /var/lib/apt/lists/* # Clean up to reduce image size

# Download and install WP-CLI (WordPress Command Line Interface)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \ # Download WP-CLI
    && chmod +x wp-cli.phar \ # Make it executable
    && mv wp-cli.phar /usr/local/bin/wp # Move to a directory in PATH

# Copy the custom start script to the container
COPY tools/start.sh /usr/local/bin/start.sh

# Copy the PHP configuration file to the container
COPY conf/php.conf /etc/php/8.1/fpm/pool.d/www.conf

# Create necessary directories and set permissions
RUN mkdir -p /run/php-fpm \ # Directory for PHP-FPM runtime files
    && mkdir -p /var/www/html \ # Directory for WordPress files
    && chown -R www-data:www-data /var/www/html \ # Set ownership to www-data
    && chmod 755 /usr/local/bin/start.sh \ # Set executable permissions for the start script
    && chmod 755 /etc/php/8.1/fpm/pool.d/www.conf # Set permissions for the PHP config file

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set the entrypoint to the custom start script
ENTRYPOINT ["/usr/local/bin/start.sh"]

# Default command to run PHP-FPM in the foreground
CMD ["php-fpm8.1", "-F"]

