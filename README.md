WordPress-Nginx
===============

WordPress specific Nginx configurations, tweaks, etc on Debian based distributions with PHP-FPM.

Tested with Nginx version 1.2.x in
+ Debian 6.x
+ Ubuntu 12.04.x

How to Install
--------------

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
sed -i --follow-symlinks 's/domainname.com/youractualdomainname.com/g' /etc/nginx/sites-enabled/domainname.conf
nginx -t && service nginx restart
```

List of changes to be done to make it work with CentOS based distributions including Amazon Linux AMI...
+ Look out for `default.conf` and `ssl.conf` in `/etc/nginx/conf.d/` and move them to a safe place for future reference.
+ Create new directories named `/etc/nginx/sites-available/` and `/etc/nginx/sites-enabled/`.
+ An include statement in `/etc/nginx/nginx.conf` that includes `/etc/nginx/conf.d/common.conf` file
+ An include statement in `/etc/nginx/conf.d/common.conf` file that includes `/etc/nginx/sites-enabled/*`
+ The file `/etc/nginx/fastcgi_params` in Debian is named as `/etc/nginx/fastcgi.conf` in CentOS.


Questions, Issues or Bugs?
--------------------------

Please contact via Github or at https://www.tinywp.in/contact/
