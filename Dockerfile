FROM comicrelief/php7-slim:7.1

LABEL Description="Metadata backend for the PhenoMeNal Portal"
LABEL software="PhenoMeNal Portal"
LABEL software.version="1.1.2"
LABEL version="0.2.2"

RUN apt-get update && apt-get install -y --no-install-recommends mysql-client
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"
RUN apt-get -y install python2.7 && apt-get -y install python-pip
RUN pip install --upgrade oauth2client
RUN git clone --depth 1 --single-branch --branch master https://github.com/phnmnl/portal-metadata-backend.git 
WORKDIR portal-metadata-backend
RUN php composer.phar install
RUN chmod a+x setup_connection.sh
ENV PATH /var/www/html/portal-metadata-backend/vendor/propel/propel/bin:$PATH

# php -S localhost:8080 -t public public/index.php
    
