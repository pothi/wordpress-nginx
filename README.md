# WordPress-Nginx

WordPress specific Nginx configurations, tweaks, compatibility routines, etc.

## Compatibility

Tested with 
+ Debian Debian 9.x (upcoming version)
+ Ubuntu 16.04.x

For Fedora, Redhat, CentOS and Amazon Linux AMI or similar distributions, please look at the [CentOS branch](https://github.com/pothi/WordPress-Nginx/tree/centos "WordPress-Nginx configuration for Amazon Linux AMI, Fedora, Redhat and CentOS based distributions").

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
# git checkout centos
cp -a $HOME/git/wordpress-nginx/{conf.d, globals, errors, sites-available} /etc/nginx/
rm /etc/nginx/sites-enabled/domainname.conf
# Other steps that depends on your particular requirement:
# YOUR_DOMAIN_NAME=tinywp.com
# mv /etc/nginx/sites-available/domainname.conf /etc/nginx/sites-available/$YOUR_DOMAIN_NAME.conf
# cd /etc/nginx/sites-enabled/
# ln -s ../sites-available/$YOUR_DOMAIN_NAME.conf
# sed -i --follow-symlinks 's/domainname.com/'$YOUR_DOMAIN_NAME'/g' /etc/nginx/sites-enabled/$YOUR_DOMAIN_NAME.conf
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
+ Thanks for having a look here. Have a good time!
