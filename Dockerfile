FROM php:8.2-fpm

# Install dependencies
RUN apt update && apt install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev

COPY --from=node:20-alpine /usr/local/bin/node /usr/local/bin/
COPY --from=node:20-alpine /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
# Add Node.js binary path to PATH
ENV PATH="/usr/local/bin:${PATH}"

# Install npm
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Clean up
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Create Laravel storage directory
RUN mkdir -p storage/logs

# Change permissions of Laravel storage directory
RUN chmod -R 775 storage

# Switch to www-data user
USER www-data

# Change ownership of Laravel storage directory
COPY --chown=www:www . /var/www
