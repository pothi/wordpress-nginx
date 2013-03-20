# WordPress-Nginx

WordPress specific Nginx configurations, tweaks, etc on Debian based distributions with PHP-FPM.

## Compatibility

Tested with Nginx version 1.2.x in
+ Debian 6.x
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

### Guidelines for CentOS
+ Look for `default.conf` and `ssl.conf` in `/etc/nginx/conf.d/` and move them to a safe place for future reference.
+ Create new directories named `/etc/nginx/sites-available/` and `/etc/nginx/sites-enabled/`.
+ Look for an include statement in `/etc/nginx/nginx.conf` that includes `/etc/nginx/conf.d/common.conf` file, among other files.
+ Look for an include statement in `/etc/nginx/conf.d/common.conf` file that includes `/etc/nginx/sites-enabled/*`, among other files.
+ The file `/etc/nginx/fastcgi_params` in Debian is named as `/etc/nginx/fastcgi.conf` in CentOS. Update the reference/s to this file. `nginx -t` would throw an error, anyway, if you don't.


## Questions, Issues or Bugs?

+ Please contact via Github or use the contact form at https://www.tinywp.in/contact/
+ I'm available for hire to setup, tweak or troubleshoot your server. :)
