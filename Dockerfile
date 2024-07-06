#e the official Ubuntu base image
FROM ubuntu:latest

# Set non-interactive mode for apt-get to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install sudo wget curl -y

RUN cd

# Copy your setup script into the container
#RUN wget http://stevennkeneng.com/setup.sh

COPY ./setup.sh .

# Make the setup script executable
RUN chmod u+x ./setup.sh

# Run your setup script
RUN ./setup.sh

# Update package lists and install required packages
RUN apt-get install -y \
    build-essential \
    libxml2-dev \
    libssl-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    libmysqlclient-dev \
    libreadline-dev \
    libtidy-dev \
    libxslt-dev \
    libzip-dev \
    re2c \
    bison \
    autoconf \
    automake \
    php \
    php-xml \
    pkg-config \
    ca-certificates \
    sqlite3 \
    libsqlite3-dev \
    libonig-dev \
    --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# Install phpbrew
RUN wget -O /usr/local/bin/phpbrew https://github.com/phpbrew/phpbrew/releases/latest/download/phpbrew.phar && \
    chmod +x /usr/local/bin/phpbrew

# Initialize phpbrew
RUN phpbrew init
RUN phpbrew install -j $(nproc) 8.3 +default +sqlite +bcmath

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Source phpbrew script
RUN cat /root/.phpbrew/bashrc >> /root/.zshrc

# Command to start bash
CMD ["bash"]
