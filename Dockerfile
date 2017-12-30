FROM crs4/php7-base:7.1

LABEL Description="Metadata backend for the PhenoMeNal Portal"
LABEL software="PhenoMeNal Portal"
LABEL software.version="1.1.2"
LABEL version="0.2.2"

# Optional arguments to choose the Git repo & branch to use at build time
ARG git_repo=phnmnl/portal-metadata-backend
ARG git_branch=master

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends mysql-client python2.7 python-pip && \
    pip install --upgrade oauth2client && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    rm -rf /var/lib/apt/lists/*

# Download the PortalMetadataBackend
RUN echo "Cloning branch '${git_branch}' of the Git repository '${git_repo}'" >&2 && \
    git clone --depth 1 --single-branch --branch ${git_branch} https://github.com/${git_repo}.git

# Set working directory
WORKDIR portal-metadata-backend

# php -S localhost:8080 -t public public/index.php
# Install backend dependencies
RUN php composer.phar install && chmod a+x setup.sh

# Set environment
ENV MYSQL_HOST "localhost"
ENV MYSQL_PORT 3306
ENV SERVICE_PATH "/var/www/html/portal-metadata-backend"
ENV PATH ${SERVICE_PATH}/vendor/propel/propel/bin:${PATH}
    
