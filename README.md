# WordPress-Nginx

WordPress specific Nginx configurations, tweaks, etc on Debian based distributions with PHP-FPM.

## Compatibility

Tested with Nginx version 1.4.x in
+ Debian 6.x & Debian 7.x
+ Ubuntu 12.04.x

For CentOS based distributions, please look for the guidelines below, on the list of changes to be done in order to make this configuration to work.

## How to Install

Please backup your old configuration files...

```bash
mkdir $HOME/nginx-backup
cp -a /etc/nginx/* $HOME/nginx-backup
```

As 'root', please use the following guidelines...
```bash
cd $HOME
git clone git://github.com/pothi/WordPress-Nginx.git git/wp-nginx
cp -a git/wp-nginx/* /etc/nginx/
# Optional steps:
# remove the existing symlink at /etc/nginx/sites-enabled/domainname.conf
# rename /etc/nginx/sites-available/domainname.conf
# create a symlink of the above file to /etc/nginx/sites-enabled
sed -i --follow-symlinks 's/domainname.com/YourDomain.com/g' /etc/nginx/sites-enabled/domainname.conf
nginx -t && service nginx restart
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
