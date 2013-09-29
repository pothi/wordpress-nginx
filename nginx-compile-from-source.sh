#!/bin/bash

# What it is: a script to compile and install nginx manually in Ubuntu 12.04 server. It may (not) work with Debian.
# Author: Pothi Kalimuthu
# Author URL: http://pothi.info
# License: GPL v2

### VARIABLES ###

# Please know that this script should be executed as normal user with __sudo__ privileges.

# Pre-requisites to compile Nginx from source
PRE_PACK="gcc make libpcre3-dev zlib1g-dev libssl-dev libgeoip-dev"

# Change the following to whatever the current version.
# You can know the current versino at http://nginx.org
CURRENT_VER="1.4.2"

# Be careful, in choosing this value.
# Valid values are "BINARY", "NULL", "currently_installed_version_number"
# Use "NULL" - If your server hasn't got Nginx now.
# Use "BINARY" - If your server has __already__ got Nginx that was installed using "sudo apt-get install nginx" command.
# Use "currently_installed_version_number" - If your server has already got Nginx that was installed using this script.
PREV_VER="BINARY"

# This may change, depending on your requirement.
# The following _may_ fit most use-cases
CONFIGURE_OPTIONS="--user=www-data --group=www-data
                    --prefix=/usr/local/nginx-$CURRENT_VER
                    --sbin-path=/usr/sbin/nginx
                    --conf-path=/etc/nginx/nginx.conf
                    --pid-path=/var/run/nginx.pid
                    --error-log-path=/var/log/nginx/error.log
                    --http-log-path=/var/log/nginx/access.log

                    --with-http_ssl_module
                    --with-http_realip_module
                    --with-http_geoip_module
                    --with-http_stub_status_module
                    --with-http_sub_module
                    --with-http_flv_module
                    --with-http_gzip_static_module
                    --with-http_secure_link_module
                    --with-ipv6

                    "

# If you use ngx_pagespeed, install the dependencies for it by uncommenting the lines with the heading "Pagespeed Module"

### You _may_ not need to edit below this line ###

CWD=$(pwd)
USER_BIN="/usr/sbin"

if [ $PREV_VER == 'NULL' ]
    then
        echo 'Installing Nginx from Ubuntu repo, to install the dependencies'
        echo
        sudo apt-get -y -q install nginx &> /dev/null
        if [ "$?" != '0' ]; then
            echo 'Something wrent wrong while installing Nginx from official repo. Probably you do not have sudo privilege!'
            exit 1
        fi

        # Now we don't need Nginx binary. Let's remove it
        sudo apt-get -y remove nginx nginx-common nginx-full &> /dev/null
        sudo apt-get autoremove -y &> /dev/null
        if [ "$?" != '0' ]; then
            echo 'Something wrent wrong while removing Nginx that was installed via official repo'
            exit 1
        fi

        # install the prerequisites
        echo "Installing development packages..."
        sudo apt-get -y -q install $PRE_PACK &> /dev/null
        if [ "$?" != '0' ]; then
            echo 'Something wrent wrong while installing the development packages'
            exit 1
        fi

        # Pagespeed Module
        # echo 'Installing mod_pagespeed dependencies...'
        # sudo apt-get -y -q install git-core build-essential zlib1g-dev libpcre3 libpcre3-dev &> /dev/null
        # if [ "$?" != '0' ]; then
            # echo 'Something wrent wrong while installing the dependencies for pagespeed'
            # exit 1
        # fi

    elif [ $PREV_VER == "BINARY" ]; then
        echo "Installing development packages..."
        sudo apt-get -y -q install $PRE_PACK &> /dev/null
        if [ "$?" != '0' ]; then
            echo 'Something wrent wrong while installing the development packages. Probably, you do not have sudo privilege!'
            exit 1
        fi

    elif [ $CURRENT_VER == $PREV_VER ]
        then
            echo 'Recompiling the current version!'

    else
        echo "Upgrading from version $PREV_VER to $CURRENT_VER!"
fi

# create a new directory to download source and compile
COMPILE_DIR=$HOME/src/nginx-$(date +%F_%H-%M-%S)
mkdir -p $COMPILE_DIR
cd $COMPILE_DIR &> /dev/null

# download and install nginx
echo 'Hold on! Downloading Nginx...'
wget -q http://nginx.org/download/nginx-$CURRENT_VER.tar.gz
tar xzf nginx-$CURRENT_VER.tar.gz && rm -f nginx-$CURRENT_VER.tar.gz; cd nginx-$CURRENT_VER
if [ "$?" != '0' ]; then
    echo 'Something wrent wrong while downloading Nginx'
    exit 1
fi

# download custom modules
# git clone git://github.com/yaoweibin/ngx_http_substitutions_filter_module.git
# git clone https://github.com/pagespeed/ngx_pagespeed.git

echo 'Please wait! Configuring Nginx!'
./configure $CONFIGURE_OPTIONS &> /dev/null
if [ "$?" != '0' ]; then
    echo 'Something wrent wrong while configuring Nginx'
    exit 1
fi

echo 'Making the new version. This process may take several minutes depending on the CPU!'
sudo make
if [ "$?" != '0' ]; then
    echo 'Something wrent wrong while making Nginx'
    exit 1
fi

if [ $PREV_VER == "BINARY" ]; then
    sudo apt-get -y remove nginx nginx-common nginx-full &> /dev/null

    if [ "$?" != '0' ]; then
        echo 'Something wrent wrong while removing Nginx that was installed via official repo'
        exit 1
    fi
fi

echo 'Installing Nginx'
sudo make install
if [ "$?" != '0' ]; then
    echo 'Something wrent wrong while installing Nginx'
    exit 1
fi

# (re)start Nginx server
if [ $PREV_VER == 'NULL' ]; then
    # http://wiki.nginx.org/Nginx-init-ubuntu
    # mv /root/nginx-init /etc/init.d/nginx

    # In Ubuntu 12.04, the following is not needed
    # /usr/sbin/update-rc.d -f nginx defaults

    # Start Nginx for the first time
    sudo nginx -t && sudo service nginx start

elif [ $PREV_VER == "BINARY" ]; then
    sudo nginx -t && sudo service nginx start
else
    # Upgrade Nginx
    sudo nginx -t && sudo make upgrade
fi
if [ "$?" != '0' ]; then
    echo 'Something wrent wrong while (re)starting Nginx'
    exit 1
fi

# clean up
rm -rf $COMPILE_DIR &> /dev/null
cd $CWD &> /dev/null

echo "done."; echo

exit 0
