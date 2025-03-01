FROM ubuntu:22.04

# Set our our meta data for this container.
LABEL name="FlyingFlip Studios, LLC. Platform Docker Container"
LABEL author="Michael R. Bagnall <mbagnall@flyingflip.com>"

WORKDIR /root

ENV TERM=xterm

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/www/html/vendor/drush/drush:vendor/drush/drush:/var/www/html/drush/drush:/var/www/html/docroot/vendor/drush/drush

# Update to NodeJS 16 and install nvm for supporting other versions.
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install curl dirmngr apt-transport-https lsb-release ca-certificates sudo apt-utils wget gnupg && \
  mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
  export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

# Update apt repos and install base apt packages.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  git \
  libnss3 \
  memcached \
  nano \
  netcat-openbsd \
  nodejs \
  ntp \
  redis-server \
  sendmail \
  software-properties-common \
  sudo \
  vim \
  wget \
  zip \
  gcc \
  g++ \
  make \
  mariadb-client \
  postgresql-client \
  curl \
  msmtp \
  net-tools \
  python3 \
  gettext \
  rsync \
  unzip \
  ghostscript \
  logrotate \
  cpanminus \
  # webalizer \
  libgd-dev \
  libgd-perl \
  libclass-dbi-pg-perl \
  libapache2-mod-perl2 \
  ffmpeg \
  mediainfo

# Install PHP, PHP packages, Postgresql, and Apache2 apt packages.
RUN apt-get install -y \
  imagemagick \
  apache2 \
  apache2-utils

# Add ondrej/php PPA repository for PHP.
RUN add-apt-repository ppa:ondrej/php \
  && apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install dialog

RUN apt-get install -y \
  php7.4 \
  php7.4-bcmath \
  php7.4-bz2 \
  php7.4-cli \
  php7.4-common \
  php7.4-curl \
  php7.4-dba \
  php7.4-gd \
  php7.4-imap \
  php7.4-json \
  php7.4-ldap \
  php7.4-mbstring \
  php7.4-mysql \
  php7.4-mysqlnd \
  php7.4-odbc \
  php7.4-opcache \
  php7.4-apcu \
  php7.4-readline \
  php7.4-soap \
  php7.4-zip \
  php7.4-pgsql \
  php7.4-dev \
  php7.4-xml \
  php7.4-imagick \
  php7.4-intl \
  php7.4-mongodb \
  php7.4-redis \
  php7.4-memcached \
  php7.4-uploadprogress \
  libapache2-mod-php7.4

  RUN apt-get install -y \
  php8.4 \
  php8.4-bcmath \
  php8.4-bz2 \
  php8.4-cli \
  php8.4-common \
  php8.4-curl \
  php8.4-dba \
  php8.4-dev \
  php8.4-gd \
  php8.4-ldap \
  php8.4-mbstring \
  php8.4-mysql \
  php8.4-opcache \
  php8.4-apcu \
  php8.4-readline \
  php8.4-soap \
  php8.4-zip \
  php8.4-pgsql \
  php8.4-dev \
  php8.4-xml \
  php8.4-intl \
  php8.4-redis \
  php8.4-memcached \
  php8.4-uploadprogress \
  libapache2-mod-php8.4

RUN apt-get install -y \
  php8.3 \
  php8.3-bcmath \
  php8.3-bz2 \
  php8.3-cli \
  php8.3-common \
  php8.3-curl \
  php8.3-dba \
  php8.3-dev \
  php8.3-gd \
  php8.3-ldap \
  php8.3-mbstring \
  php8.3-mysql \
  php8.3-opcache \
  php8.3-apcu \
  php8.3-readline \
  php8.3-soap \
  php8.3-zip \
  php8.3-pgsql \
  php8.3-dev \
  php8.3-xml \
  php8.3-intl \
  php8.3-redis \
  php8.3-memcached \
  php8.3-uploadprogress \
  libapache2-mod-php8.3

RUN apt-get install -y \
  php8.0 \
  php8.0-bcmath \
  php8.0-bz2 \
  php8.0-cli \
  php8.0-common \
  php8.0-curl \
  php8.0-dba \
  php8.0-gd \
  php8.0-ldap \
  php8.0-mbstring \
  php8.0-mysql \
  php8.0-opcache \
  php8.0-apcu \
  php8.0-readline \
  php8.0-soap \
  php8.0-zip \
  php8.0-pgsql \
  php8.0-dev \
  php8.0-xml \
  php8.0-imagick \
  php8.0-redis \
  php8.0-memcached \
  php8.0-intl \
  php8.0-mongodb \
  php8.0-uploadprogress \
  libapache2-mod-php8.0

RUN apt-get install -y \
  php8.1 \
  php8.1-bcmath \
  php8.1-bz2 \
  php8.1-cli \
  php8.1-common \
  php8.1-curl \
  php8.1-dba \
  php8.1-gd \
  php8.1-ldap \
  php8.1-mbstring \
  php8.1-mysql \
  php8.1-opcache \
  php8.1-apcu \
  php8.1-readline \
  php8.1-soap \
  php8.1-zip \
  php8.1-pgsql \
  php8.1-dev \
  php8.1-xml \
  php8.1-imagick \
  php8.1-intl \
  php8.1-mongodb \
  php8.1-redis \
  php8.1-memcached \
  php8.1-uploadprogress \
  libapache2-mod-php8.1

RUN apt-get install -y \
  php8.2 \
  php8.2-bcmath \
  php8.2-bz2 \
  php8.2-cli \
  php8.2-common \
  php8.2-curl \
  php8.2-dba \
  php8.2-dev \
  php8.2-gd \
  php8.2-ldap \
  php8.2-mbstring \
  php8.2-mysql \
  php8.2-opcache \
  php8.2-apcu \
  php8.2-mongodb \
  php8.2-readline \
  php8.2-soap \
  php8.2-zip \
  php8.2-pgsql \
  php8.2-dev \
  php8.2-xml \
  php8.2-intl \
  php8.2-redis \
  php8.2-imagick \
  php8.2-memcached \
  php8.2-uploadprogress \
  libapache2-mod-php8.2

COPY conf/proc-specific-install.sh /proc-specific-install.sh
RUN chmod 755 /proc-specific-install.sh && \
  bash /proc-specific-install.sh

RUN useradd apache2
COPY var/loading /var/loading
#COPY etc/apache2/ports.txt /etc/apache2/ports.txt
COPY etc/apache2/envvars /etc/apache2/envvars
COPY etc/apache2/apache2-auth.conf /etc/apache2/apache2-auth.conf
COPY etc/apache2/apache2-noauth.conf /etc/apache2/apache2-noauth.conf
COPY etc/apache2/sites-available/00x-loading.conf /etc/apache2/sites-available/00x-loading.conf
COPY etc/apache2/sites-available/00x-default.conf /etc/apache2/sites-available/00x-default.conf
RUN rm /etc/apache2/sites-enabled/000-default.conf
#RUN ln -s /etc/apache2/sites-available/000-loading.conf /etc/apache2/sites-enabled/000-loading.conf

COPY etc/php/7.4/apache2/php.ini /etc/php/7.4/apache2/php.ini
COPY conf/mail.ini /etc/php/7.4/apache2/conf.d/mail.ini
COPY conf/mail.ini /etc/php/7.4/cli/conf.d/mail.ini

COPY etc/php/8.0/apache2/php.ini /etc/php/8.0/apache2/php.ini
COPY conf/mail.ini /etc/php/8.0/apache2/conf.d/mail.ini
COPY conf/mail.ini /etc/php/8.0/cli/conf.d/mail.ini

COPY etc/php/8.1/apache2/php.ini /etc/php/8.1/apache2/php.ini
COPY conf/mail.ini /etc/php/8.1/apache2/conf.d/mail.ini
COPY conf/mail.ini /etc/php/8.1/cli/conf.d/mail.ini

COPY etc/php/8.2/apache2/php.ini /etc/php/8.2/apache2/php.ini
COPY conf/mail.ini /etc/php/8.2/apache2/conf.d/mail.ini
COPY conf/mail.ini /etc/php/8.2/cli/conf.d/mail.ini

COPY etc/php/8.3/apache2/php.ini /etc/php/8.3/apache2/php.ini
COPY conf/mail.ini /etc/php/8.3/apache2/conf.d/mail.ini
COPY conf/mail.ini /etc/php/8.3/cli/conf.d/mail.ini

COPY etc/php/8.4/apache2/php.ini /etc/php/8.4/apache2/php.ini
COPY conf/mail.ini /etc/php/8.4/apache2/conf.d/mail.ini
COPY conf/mail.ini /etc/php/8.4/cli/conf.d/mail.ini

# COPY conf/webalizer.conf /etc/webalizer/webalizer.conf
COPY etc/logrotate /etc/cron.daily/logrotate
COPY etc/apache2-logrotate /etc/logrotate.d/apache2

# Add our localhost certificate
ADD etc/ssl/localhost.crt /etc/ssl/certs/localhost.crt
ADD etc/ssl/localhost.key /etc/ssl/private/localhost.key

RUN echo 'Mutex posixsem' >> /etc/apache2/apache2-auth.conf
RUN echo 'Mutex posixsem' >> /etc/apache2/apache2-noauth.conf
RUN echo 'Mutex posixsem' >> /etc/apache2/apache2.conf

# Configure Apache. Be sure to enable apache mods or you're going to have a bad time.
RUN rm -rf /var/www/html \
  && a2enmod rewrite \
  && a2enmod actions \
  && a2enmod alias \
  && a2enmod deflate \
  && a2enmod dir \
  && a2enmod expires \
  && a2enmod headers \
  && a2enmod mime \
  && a2enmod negotiation \
  && a2enmod setenvif \
  && a2enmod proxy \
  && a2enmod proxy_http \
  && a2enmod speling \
  && a2enmod perl \
  && a2enmod cgid \
  && a2enmod remoteip \
  && a2enmod ssl && \
  service apache2 restart

RUN update-alternatives --set php /usr/bin/php8.2 && \
  a2dismod php7.4 && \
  a2dismod php8.0 && \
  a2dismod php8.1 && \
  a2dismod php8.2 && \
  a2dismod php8.3 && \
  a2dismod php8.4 && \
  service apache2 restart

RUN apt-get install -y mlocate

RUN pecl channel-update pecl.php.net && \
  pear install PHP_CodeSniffer

RUN curl -sS https://getcomposer.org/installer | php -- \
  --install-dir=/usr/local/bin \
  --filename=composer

RUN composer \
  --working-dir=/usr/local/src/ \
  global \
  require \
  drush/drush:^8 && \
  ln -s /usr/local/src/vendor/bin/drush /usr/bin/drush

# Add our startup message on the container.
ADD conf/startup.sh /root/.bashrc

# Our smtp mail configuration to use php mail() as our SMTP server.
ADD conf/msmtprc /home/apache2/msmtprc

# Add our logrotate configuration
ADD etc/logrotate.conf /etc/logrotate.conf

# Our startup script used to install Drupal (if configured) and start Apache.
ADD conf/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

# Install yarn
# RUN npm install --global yarn

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

RUN cpanm HTML::Template && \
  cpanm GD::Image && \
  cpanm ExtUtils::PkgConfig && \
  cpanm Crypt::Blowfish && \
  cpanm HTTP::Request && \
  cpanm --force Test::More && \
  cpanm Image::Resize && \
  cpanm CGI && \
  cpanm CGI::Carp && \
  cpanm --force Class::HPLOO && \
  cpanm --force HDB && \
  cpanm --force DBD && \
  cpanm --force DBI && \
  cpanm Net::HTTP && \
  cpanm URI && \
  cpanm JSON && \
  cpanm File::MimeInfo && \
  cpanm HTTP::Request::AsCGI && \
  cpanm LWP::Protocol::https && \
  cpanm --force Module::Pluggable && \
  cpanm Email::Abstract && \
  cpanm Email::Sender && \
  cpanm Email::Simple && \
  cpanm YAML::XS && \
  cpanm Email::Sender::Transport::SMTPS && \
  cpanm HTML::Template && \
  cpanm Email::SendGrid::V3

# Our info for the info message!
ENV VERSION=23.1
ENV BUILD_DATE="March 1, 2024"

# Install the Backdrop CMS tool Bee
RUN cd /root && \
  wget https://github.com/backdrop-contrib/bee/archive/refs/heads/1.x-1.x.zip && \
  unzip 1.x-1.x.zip && \
  mv bee-1.x-1.x bee && \
  cd /bin && \
  ln -s /root/bee/bee.php bee && \
  chmod -R 755 /root/bee/bee.php && \
  cd

WORKDIR /var

EXPOSE ${EXPOSED_HTTP_PORT}
EXPOSE ${EXPOSED_HTTPS_PORT}

CMD [ "/run-httpd.sh" ]
