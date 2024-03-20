FROM php:8.2-fpm

# Install dependencies
RUN apt update && apt install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev

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
