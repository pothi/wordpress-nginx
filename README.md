# WordPress-Nginx

WordPress specific Nginx configurations, tweaks, and much more!

## Advantages

There are multiplpe advantages of using this repo as your go-to nginx configuration.

+ Contains ready-to-use sample vhost entries to be used with WP Super Cache plugin (with SSL), WP Rocket cache plugin, etc.
+ Uses best practices (ex: you can find the correct use 'if' statement here).
+ Continuously updated sample configurations and best practices.

## Compatibility

Tested with 
+ Debian Debian 9.x (upcoming version)
+ Ubuntu 16.04 LTS

For Fedora, Redhat, CentOS and Amazon Linux AMI or similar distributions, the configuration mentioned in the repo should work. Additional steps may be needed, though. See below for some details!

## How to Install

Please backup your old configuration files...

```bash
TIMESTAMP=$(date +%F_%H-%M-%S)
mkdir $HOME/nginx-backup-$TIMESTAMP
cp -a /etc/nginx/* $HOME/nginx-backup-$TIMESTAMP
```

As __sudo or root__, please use the following guidelines...
```bash
git clone git://github.com/pothi/wordpress-nginx.git $HOME/git/wordpress-nginx
cd $HOME/git/wordpress-nginx

cp -a $HOME/git/wordpress-nginx/{conf.d, globals, errors, sites-available} /etc/nginx/
mkdir /etc/nginx/sites-enabled &> /dev/null
cp /etc/nginx/nginx-sample.conf /etc/nginx/nginx.conf

# Other steps that depends on your particular requirement:

# one-off process
# edit /etc/nginx/conf.d/lb.conf and update the upstream block for 'fpm'

# you may do the following for each vhost
# WP_DOMAIN=example.com
# YOUR_USERNAME=your_linux_username
# cp /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-available/$WP_DOMAIN.conf
# cd /etc/nginx/sites-enabled/
# ln -s ../sites-available/$WP_DOMAIN.conf
# sed -i --follow-symlinks 's/example.com/'$WP_DOMAIN'/g' /etc/nginx/sites-enabled/$WP_DOMAIN.conf
# sed -i --follow-symlinks 's/username/'$YOUR_USERNAME'/g' /etc/nginx/sites-enabled/$WP_DOMAIN.conf
# nginx -t && service nginx restart
```

### Changes on CentOS

CentOS has a different file naming convention, yet simple directory structure, when compared to Debian derivatives. Let me describe them and I'd let you decide upon how you'd want to structure your files and name those files.

+ The configuration for default sites are named as `default.conf` and `ssl.conf` in `/etc/nginx/conf.d/`.
+ There is no `sites-available` or `sites-enabled` folder.
+ The file `/etc/nginx/fastcgi_params` in Debian is named as `/etc/nginx/fastcgi.conf` in CentOS.


## Questions, Issues or Bugs?

+ Please submit issues or bugs via Github
+ Patches, improvements, and suggestions are welcomed.
+ Please use contact form at https://www.tinywp.in/contact/ , if you'd like to contact Pothi Kalimuthu for other reasons.
+ I'm available for hire to setup, tweak or troubleshoot your server to provide *the fastest WordPress hosting*.
+ Thanks for checking it out. Have a good time!
