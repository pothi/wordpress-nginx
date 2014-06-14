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
CURRENT_VER="1.6.0"

# Be careful, in choosing this value.
# Valid values are "BINARY", "NULL", "currently_installed_version_number"
# Use "NULL" - If your server hasn't got Nginx now.
# Use "BINARY" - If your server has __already__ got Nginx that was installed using "sudo apt-get install nginx" command.
# Use "currently_installed_version_number" - If your server has already got Nginx that was installed using this script.
PREV_VER="BINARY"

# To disable PageSpeed module...
# Step #1 - set VERSION_PAGESPEED_MODULE="NULL"
# Step #2 - remove the line "--add-module=$HOME/src/ngx_pagespeed-release-${VERSION_PAGESPEED_MODULE}-beta" in CONFIGURE_OPTIONS
VERSION_PAGESPEED_MODULE="1.7.30.1"

# This may change, depending on your requirement.
# The following _may_ fit most use-cases
CONFIGURE_OPTIONS="--user=www-data --group=www-data
                    --prefix=/usr/local/nginx-$CURRENT_VER
                    --sbin-path=/usr/sbin/nginx
                    --conf-path=/etc/nginx/nginx.conf
                    --pid-path=/var/run/nginx.pid
                    --lock-path=/var/run/subsys/nginx
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

                    --with-debug
                    --add-module=ngx_pagespeed-release-${VERSION_PAGESPEED_MODULE}-beta

                    "

# If you use ngx_pagespeed, install the dependencies for it by uncommenting the lines with the heading "Pagespeed Module"

### You _may_ not need to edit below this line ###

CWD=$(pwd)
USER_BIN="/usr/sbin"

if [ $PREV_VER == 'NULL' ]
    then
        echo 'Install Nginx dependencies'
        echo
        sudo apt-get -y -q install libgd2-noxpm libjpeg8 libpng12-0 libxslt1.1 &> /dev/null
        if [ "$?" != '0' ]; then
            echo 'Something wrent wrong while installing Nginx dependencies. Probably you do not have sudo privilege!'
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
        if [ $VERSION_PAGESPEED_MODULE != 'NULL' ]; then
            echo 'Installing mod_pagespeed dependencies...'
            sudo apt-get -y -q install git-core build-essential zlib1g-dev libpcre3 libpcre3-dev &> /dev/null
            if [ "$?" != '0' ]; then
                echo 'Something wrent wrong while installing the dependencies for pagespeed'
                exit 1
            fi
        fi

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

#--- Download Nginx Pagespeed module ---#
# Ref: https://github.com/pagespeed/ngx_pagespeed#how-to-build
if [ $VERSION_PAGESPEED_MODULE != 'NULL' ]; then
    echo 'Hold on while downloading PageSpeed module...'
    wget -q https://github.com/pagespeed/ngx_pagespeed/archive/release-${VERSION_PAGESPEED_MODULE}-beta.zip &> /dev/null
    unzip -q release-${VERSION_PAGESPEED_MODULE}-beta.zip && rm release-${VERSION_PAGESPEED_MODULE}-beta.zip &> /dev/null # or unzip release-${VERSION_PAGESPEED_MODULE}-beta
    cd ngx_pagespeed-release-${VERSION_PAGESPEED_MODULE}-beta/ &> /dev/null
    wget -q https://dl.google.com/dl/page-speed/psol/${VERSION_PAGESPEED_MODULE}.tar.gz &> /dev/null
    tar -xzf ${VERSION_PAGESPEED_MODULE}.tar.gz # expands to psol/
fi

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
    wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O ~/nginx-init -q &> /dev/null
    sed -i 's:\(DAEMON=\).*:\1/usr/sbin/nginx:' ~/nginx-init
    sed -i 's:\(PIDSPATH=\).*:\1/var/run:' ~/nginx-init
    sed -i 's:\(NGINX_CONF_FILE=\).*:\1/etc/nginx/nginx.conf:' ~/nginx-init
    sudo mv ~/nginx-init /etc/init.d/nginx
    chmod +x /etc/init.d/nginx

    # In Ubuntu 12.04, the following is not needed
    sudo /usr/sbin/update-rc.d -f nginx defaults

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
rm -f ~/nginx-init &> /dev/null
rm -rf ~/src/ngx_pagespeed-release-${VERSION_PAGESPEED_MODULE}-beta/ &> /dev/null
rm -rf $COMPILE_DIR &> /dev/null
cd $CWD &> /dev/null

echo "done."; echo

exit 0

