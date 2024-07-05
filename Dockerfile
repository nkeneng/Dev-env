# Start with a base image that supports multiple PHP versions
FROM debian:bullseye-slim

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    vim \
    curl \
    wget \
    git \
    unzip \
    build-essential \
    libxml2-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libonig-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libzip-dev \
    libbz2-dev \
    libxslt-dev \
    libreadline-dev \
    libicu-dev \
    libmcrypt-dev \
    bison \
    re2c \
    autoconf \
    php \
    php-xml \
    pkg-config \
    && apt-get clean

# Install phpbrew
RUN curl -L -O https://github.com/phpbrew/phpbrew/releases/latest/download/phpbrew.phar \
    && chmod +x phpbrew.phar \
    && mv phpbrew.phar /usr/local/bin/phpbrew

# Initialize phpbrew
RUN phpbrew init

RUN phpbrew install -j $(nproc) 8.3 +default +sqlite

# Copy your setup script into the container
RUN wget https://stevennkeneng.com/setup.sh

# Make the setup script executable
RUN chmod +x ./setup.sh

# Run your setup script
RUN ./setup.sh

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Expose port 80
EXPOSE 80

# Set the default command
CMD ["zsh"]
