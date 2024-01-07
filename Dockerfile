ARG UNIT_VERSION=1.31.1
ARG PHP_VERSION=8.2
FROM unit:${UNIT_VERSION}-php${PHP_VERSION}

ARG UID=1000
ARG GID=1000
ENV UID=${UID}
ENV GID=${GID}

RUN apt-get -y update \
    && apt-get -y install git

# PHP Extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/download/2.1.75/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd curl intl json mbstring pgsql pdo_pgsql redis zip opcache bcmath pcntl

# Composer
ADD https://getcomposer.org/installer /tmp/composer
RUN php /tmp/composer --install-dir=/usr/bin --filename=composer

RUN usermod -u $UID www-data \
    && groupmod -g $GID www-data

LABEL org.opencontainers.image.source="https://github.com/s-shiryaev/nginx-unit-php"
LABEL org.opencontainers.image.documentation="https://github.com/s-shiryaev/nginx-unit-php"
LABEL org.opencontainers.image.authors="Sergey Shiryaev <shiryaevser@gmail.com>"
LABEL org.opencontainers.image.version=$PHP_VERSION

WORKDIR /var/www/html

CMD ["unitd", "--no-daemon"]
