# Use the official Debian Bullseye image as the base image
FROM debian:bullseye

# Update package lists, install nginx and openssl, clean up to reduce image size
RUN apt-get update && apt-get install -y nginx openssl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set an environment variable for the domain name
ENV DOMAIN_NAME=${DOMAIN_NAME}

# Copy the custom nginx configuration file to the container
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create a directory for the website files
RUN mkdir -p /var/www/html/$DOMAIN_NAME
# Create a directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate and private key
RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/private.key -out /etc/nginx/ssl/certificate.crt -days 365 -nodes -subj "/C=US/ST=State/L=City/O=Company/OU=Org/CN=$DOMAIN_NAME"
# Set permissions on the private key for security
RUN chmod 600 /etc/nginx/ssl/private.key

# Expose port 443 for HTTPS traffic
EXPOSE 443
# Expose port 9000 for additional services (e.g., PHP-FPM)
EXPOSE 9000

# Start nginx in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]

