############################################
# Base Image
############################################

# Learn more about the Server Side Up PHP Docker Images at:
# https://serversideup.net/open-source/docker-php/
FROM serversideup/php:8.2-unit as base

# Switch to root so we can do root things
USER root

COPY ./.dockerdata/entrypoint.d /etc/entrypoint.d

# Install the intl extension with root permissions
RUN install-php-extensions intl bcmath gd exif ftp


############################################
# Production Image
############################################
FROM base as release

ENV LECONFE_VERSION=1.3.0-beta.4 \
    APP_DIR=/var/www/html

	
# Download and extract OJS
ADD https://github.com/leconfe/leconfe/releases/download/${LECONFE_VERSION}/leconfe-${LECONFE_VERSION}.tar.gz /tmp/

# Create the public directory
RUN mkdir -p $APP_DIR/public

RUN tar -xzf /tmp/leconfe-${LECONFE_VERSION}.tar.gz -C /var/www/html 
RUN rm /tmp/leconfe-${LECONFE_VERSION}.tar.gz

RUN chown -R www-data:www-data $APP_DIR

ENV SSL_MODE=mixed
ENV SHOW_WELCOME_MESSAGE=false

USER www-data
