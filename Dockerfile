FROM comicrelief/php7-slim:7.1

LABEL Description="Metadata backend for the PhenoMeNal Portal"
LABEL software="PhenoMeNal Portal"
LABEL software.version="1.0.0-alpha.0"
LABEL version="0.1"

RUN apt-get update && apt-get install -y --no-install-recommends mysql-client
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"
RUN git clone --depth 1 --single-branch --branch master https://github.com/phnmnl/portal-metadata-backend.git 
WORKDIR portal-metadata-backend
RUN php composer.phar install
RUN chmod a+x setup_connection.sh
ENV PATH /var/www/html/portal-metadata-backend/vendor/propel/propel/bin:$PATH

# php -S localhost:8080 -t public public/index.php
    
