FROM crs4/php7-base:7.1

# File Author / Maintainer
MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

# Image Metadata
LABEL Description="Metadata backend for the PhenoMeNal Portal"
LABEL software="PhenoMeNal Portal"
LABEL software.version="1.2.0"
LABEL version="1.0.0"

# Optional arguments to choose the Git repo & branch to use at build time
ARG git_repo=phnmnl/portal-metadata-backend
ARG git_branch=develop

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

# Install backend dependencies
RUN php composer.phar install && chmod a+x setup.sh

# Set environment
ENV MYSQL_HOST "localhost"
ENV MYSQL_PORT 3306
ENV SERVICE_PATH "/var/www/html/portal-metadata-backend"
ENV PATH ${SERVICE_PATH}/vendor/propel/propel/bin:${PATH}

# Add utility to wait for MySQL service
ADD wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod +x /usr/local/bin/wait-for-it

# Add entrypoint script
ADD entrypoint.sh /usr/local/bin/entrypoint.sh

# Default command
CMD ["wait-for-it", "-t", "120", "${MYSQL_HOST}:${MYSQL_PORT}", "--", "entrypoint.sh"]

# Container ports
EXPOSE 8888
    
