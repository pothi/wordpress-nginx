WordPress-Nginx
===============

WordPress specific Nginx configurations, tweaks, etc.

Tested with Nginx version 1.2.x in
+ Amazon Linux AMI 2012.xx (and above)
+ Cent OS 6.x
+ Debian 6.x
+ Ubuntu 12.04.x

How to Install
--------------

Please backup your old configuration files...

+ `mkdir $HOME/nginx-backup`
+ `cp -a /etc/nginx/* $HOME/nginx-backup`

As 'root', please use the following guidelines...
+ `cd $HOME`
+ `git clone git://github.com/pothi/WordPress-Nginx.git git/wp-nginx`
+ `cp -a git/wp-nginx/* /etc/nginx/`
+ Edit `/etc/nginx/sites-enabled/domainname.conf` to fit your specific site / domain
+ `nginx -t` (to check if everything is okay)

Things to Watchout
------------------

+ An include statement in `/etc/nginx/nginx.conf` that includes `/etc/nginx/conf.d/common.conf` file
+ An include statement in `/etc/nginx/conf.d/common.conf` file that includes `/etc/nginx/sites-enabled/*`
+ *Please please please*, take a backup of all your Nginx related configurations!
+ Remove any default files such as `defaults.conf` and `ssl.conf` inside `/etc/nginx/conf.d/` or inside `/etc/nginx/sites-enabled/`.

Questions, Issues or Bugs?
--------------------------

Please contact via Github or at https://www.tinywp.in/contact/
