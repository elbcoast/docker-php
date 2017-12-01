ARG PHP_VERSION=7
FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="pierre@elbcoast.net"
LABEL description="Php images optimized for development in docker-compose files"

# Install dependencies
RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
    && apk add --no-cache \
        git \
        freetype \
        libpng \
        libjpeg-turbo \
        libmcrypt \
        icu \
        shadow \
    && apk add --no-cache --virtual .php-deps \
        icu-dev \
        libxml2-dev \
        libmcrypt-dev \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-libxml-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} iconv mcrypt mbstring intl gd pdo pdo_mysql zip exif xml \
    && apk del .php-deps

ADD php.ini /usr/local/etc/php/php.ini


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -ex \
	&& apk add --no-cache --virtual .gosu-deps \
		dpkg \
		gnupg \
		openssl \
	&& dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ipv4.pool.sks-keyservers.net  --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apk del .gosu-deps


ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www

ENTRYPOINT ["entrypoint.sh"]