#!/bin/bash

apt-get -y install wkhtmltopdf

if [ -e '/usr/lib/x86_64-linux-gnu/libQt5Core.so.5' ]
then  
  strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
  wget https://download.docker.com/linux/static/stable/x86_64/docker-25.0.3.tgz
  tar -xvzf docker-25.0.3.tgz
  cp docker/* /usr/bin/
  apt-get -y install libleveldb-dev
  git clone https://github.com/reeze/php-leveldb.git
  cd php-leveldb
  phpize
  ./configure
  make
  make install
  cd ../
  echo "extension=leveldb.so" > /etc/php/8.2/apache2/conf.d/S20-leveldb.ini
  echo "extension=leveldb.so" > /etc/php/8.1/apache2/conf.d/S20-leveldb.ini
  echo "extension=leveldb.so" > /etc/php/8.3/apache2/conf.d/S20-leveldb.ini
  echo "extension=leveldb.so" > /etc/php/8.3/cli/conf.ed/S20-leveldb.ini
  echo "extension=leveldb.so" > /etc/php/8.2/cli/conf.ed/S20-leveldb.ini
  echo "extension=leveldb.so" > /etc/php/8.1/cli/conf.ed/S20-leveldb.ini
else
  strip --remove-section=.note.ABI-tag /usr/lib/aarch64-linux-gnu/libQt5Core.so.5
  wget https://download.docker.com/linux/static/stable/aarch64/docker-25.0.3.tgz
  tar -xvzf docker-25.0.3.tgz
  cp docker/* /usr/bin/
fi
