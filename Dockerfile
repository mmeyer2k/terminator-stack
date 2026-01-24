FROM dunglas/frankenphp:1.11-php8.5.2-trixie

ARG WWWUSER=sail
ARG WWWGROUP=sail

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y htop git unzip

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::BrokenProxy    true;" >> /etc/apt/apt.conf.d/99custom

RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN docker-php-ext-install pdo_mysql pcntl

RUN useradd ${WWWUSER}

# Add additional capability to bind to port 80 and 443
RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp

# Give write access to /config/caddy and /data/caddy
RUN chown -R ${WWWUSER}:${WWWUSER} /config/caddy /data/caddy /usr/local/bin/frankenphp

#RUN groupadd --force -g $WWWGROUP sail
#RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 sail
#RUN git config --global --add safe.directory /var/www/html

#COPY start-container /usr/local/bin/start-container
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#COPY php.ini /etc/php/8.5/cli/conf.d/99-sail.ini
#RUN chmod +x /usr/local/bin/start-container

EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 443/udp

USER ${WWWUSER}

#ENTRYPOINT ["start-container"]
