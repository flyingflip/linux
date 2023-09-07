#!/bin/bash

if [ -e '/usr/lib/x86_64-linux-gnu/libQt5Core.so.5' ]
then
  apt-get -y install wkhtmltopdf
  strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
  wget https://download.docker.com/linux/static/stable/x86_64/docker-24.0.6.tgz
  tar -xvzf docker-24.0.6.tgz
  cp docker/* /usr/bin/

  apt-get -y install libleveldb-dev
  git clone https://github.com/reeze/php-leveldb.git
  cd php-leveldb
  phpize
  ./configure
  make
  make install
  cd ../
else
  apt-get -y install wkhtmltopdf
  strip --remove-section=.note.ABI-tag /usr/lib/aarch64-linux-gnu/libQt5Core.so.5
  wget https://download.docker.com/linux/static/stable/aarch64/docker-24.0.6.tgz
  tar -xvzf docker-24.0.6.tgz
  cp docker/* /usr/bin/

fi

