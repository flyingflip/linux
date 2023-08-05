#!/bin/bash

if [ ! -v DOCROOT ]; then
  echo "-------------------------------------------------------------------------------"
  echo "Fatal Web Error: DOCROOT not explicityly set. Default of /var/www will be used."
  echo "Container will not launch if DOCROOT not in this location. See documentation."
  echo "-------------------------------------------------------------------------------"
  export DOCROOT="/var/www"
fi

if [ ! -v PHP_VERSION ]; then
  echo "Warning: PHP_VERSION not set. Default of PHP 8.2 (php8.2) enabled."
fi

# Handle HTACCESS conditions if configured.
if [[ -n "${HTACCESS_DESCRIPTION}" ]]; then
  /usr/bin/htpasswd -cb /var/www/.htpasswd $HTACCESS_USERNAME $HTACCESS_PASSWORD
  perl -pe 's/-\$(\{)?([a-zA-Z_]\w*)(?(1)\})/$ENV{$2}/g' < /etc/apache2/apache2-auth.conf > /etc/apache2/apache2.conf
else
  perl -pe 's/-\$(\{)?([a-zA-Z_]\w*)(?(1)\})/$ENV{$2}/g' < /etc/apache2/apache2-noauth.conf > /etc/apache2/apache2.conf
fi

# envsubst < /etc/apache2/ports.txt > /etc/apache2/ports.conf
if [ -f "/data/webalizer.conf" ]; then
  cp -f /data/webalizer.conf /etc/webalizer/webalizer.conf
fi

service apache2 start
service cron start

# Add an HSTS header if configured.
if [[ -z "${HSTS_HEADER}" ]] || [[ $HSTS_HEADER = "0" ]]; then
  export HSTS_HEADER=''
else
  if [[ -n "${HSTS_TTL}" ]]; then
    export HSTS_TTL="max-age=$HSTS_TTL;"
  else
    export HSTS_TTL="max-age=3600;"
  fi

  if [[ -n "${HSTS_PRELOAD}" ]] && [[ $HSTS_PRELOAD = "1" ]]; then
    export HSTS_PRELOAD='; preload'
  else
    export HSTS_PRELOAD=''
  fi
  export HSTS_HEADER="Header always set Strict-Transport-Security \"${HSTS_TTL} includeSubDomains${HSTS_PRELOAD}\""
fi

envsubst < /home/apache2/msmtprc > /home/apache2/.msmtprc
chown apache2 /home/apache2/.msmtprc
chmod 600 /home/apache2/.msmtprc

# Set our PHP ini environment variable defauts.
if [[ ! -n "${PHP_DISPLAY_ERRORS}" ]]; then
  export PHP_DISPLAY_ERRORS=Off
fi
if [[ ! -n "${PHP_DISPLAY_STARTUP_ERRORS}" ]]; then
  export PHP_DISPLAY_STARTUP_ERRORS=Off
fi
if [[ ! -n "${PHP_MAX_EXECUTION_TIME}" ]]; then
  export PHP_MAX_EXECUTION_TIME=300
fi
if [[ ! -n "${PHP_MAX_INPUT_TIME}" ]]; then
  export PHP_MAX_INPUT_TIME=300
fi
if [[ ! -n "${PHP_MAX_INPUT_VARS}" ]]; then
  export PHP_MAX_INPUT_VARS=1000
fi
if [[ ! -n "${PHP_MEMORY_LIMIT}" ]]; then
  export PHP_MEMORY_LIMIT=386M
fi
if [[ ! -n "${PHP_POST_MAX_SIZE}" ]]; then
  export PHP_POST_MAX_SIZE=256M
fi
if [[ ! -n "${PHP_UPLOAD_MAX_FILESIZE}" ]]; then
  export PHP_UPLOAD_MAX_FILESIZE=256M
fi
if [[ -n "${XDEBUG}" ]] || [[ $XDEBUG = "1" ]]; then
  yum install -y php-pecl-xdebug
fi

envsubst < /etc/php/7.4/apache2/php.ini > /etc/php/7.4/apache2/php2.ini
envsubst < /etc/php/7.4/cli/php.ini > /etc/php/7.4/cli/php2.ini
mv -f /etc/php/7.4/apache2/php2.ini /etc/php/7.4/apache2/php.ini
mv -f /etc/php/7.4/cli/php2.ini /etc/php/7.4/cli/php.ini

envsubst < /etc/php/8.0/apache2/php.ini > /etc/php/8.0/apache2/php2.ini
envsubst < /etc/php/8.0/cli/php.ini > /etc/php/8.0/cli/php2.ini
mv -f /etc/php/8.0/apache2/php2.ini /etc/php/8.0/apache2/php.ini
mv -f /etc/php/8.0/cli/php2.ini /etc/php/8.0/cli/php.ini

envsubst < /etc/php/8.1/apache2/php.ini > /etc/php/8.1/apache2/php2.ini
envsubst < /etc/php/8.1/cli/php.ini > /etc/php/8.1/cli/php2.ini
mv -f /etc/php/8.1/apache2/php2.ini /etc/php/8.1/apache2/php.ini
mv -f /etc/php/8.1/cli/php2.ini /etc/php/8.1/cli/php.ini

envsubst < /etc/php/8.2/apache2/php.ini > /etc/php/8.2/apache2/php2.ini
envsubst < /etc/php/8.2/cli/php.ini > /etc/php/8.2/cli/php2.ini
mv -f /etc/php/8.2/apache2/php2.ini /etc/php/8.2/apache2/php.ini
mv -f /etc/php/8.2/cli/php2.ini /etc/php/8.2/cli/php.ini

if [[ -d "/sites-enabled" ]]; then
  cp -rf /sites-enabled/* /etc/apache2/sites-enabled/.
fi

if [[ -d "/conf-enabled" ]]; then
  cp -rf /conf-enabled/* /etc/apache2/conf-enabled/.
fi

if [[ -d "/ssl" ]]; then
  mkdir /etc/apache2/ssl
  cp -rf /ssl/* /etc/apache2/ssl/.
fi

# Symlink appropriate directories into the drupal document root
# It would be good to have a more dynamic way to do this
# to support other use cases
if [ -f "$DOCROOT/../.mounts" ]; then
  while read p; do
    src=$(echo $p | cut -f1 -d:)
    dst=$(echo $p | cut -f2 -d:)

    # Removes existing files and directories without existing symlinks as a precaution
    if [[ !(-L "$dst") && -e "$dst" ]]; then
      rm -fR "$dst"
    fi

    # Make sure the directory one level above $dest so the symbolic link will not fail
    mkdir -p ${dst%/*}

    ln -sf $src $dst
    chmod -R 777 $dst

    echo $src $dst
  done < $DOCROOT/../.mounts
fi

# If we have a .cpan file, then we want to install the packages.
if [ -f "$DOCROOT/../.cpan" ]; then
  while read p; do
    cpanm -i $p
  done < $DOCROOT/../.cpan
fi

# Switch over from our loading screen and change the permissions of 
# the web files to the Apache user.
rm -rf /etc/apache2/sites-available/000-loading.conf
rm -rf /etc/apache2/sites-enabled/000-loading.conf
envsubst < /etc/apache2/sites-available/000-defaulta.conf > /etc/apache2/sites-available/000-default.conf
ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

if [[ -n "${PHP_VERSION}" ]]; then

  shopt -s extglob
  if [[ $PHP_VERSION == @(php5.6|php7.4|php8.0|php8.1|php8.2) ]]; then
    echo "PHP set to version $PHP_VERSION"
  else
    echo "PHP version $PHP_VERSION is not valid. Valid values: php7.4, php8.0 and php8.1. Set to php7.4 by default"
    export PHP_VERSION='php8.2'
  fi

  a2enmod ${PHP_VERSION}
  sudo update-alternatives --set php /usr/bin/${PHP_VERSION}
  service apache2 restart
else
  a2enmod php8.2
  sudo update-alternatives --set php /usr/bin/php8.2
  service apache2 restart
  cho "PHP set to version php8.2"
fi

touch ~/placeholder.txt
tail -f ~/placeholder.txt