# WordPress-Nginx

WordPress specific Nginx configurations, tweaks, etc on Fedora, Redhat & CentOS based distributions with PHP-FPM.

## Compatibility

It is a work in progress. I plan to test it on the following...

+ Amazon Linux AMI (2013.x+)
+ Fedora 19+
+ CentOS 6+

Since, I haven't tested on these yet, I'm glad to install and set it up on your server for free! In return, you'd be thanked here for providing the test machine!

## How to Install

Please backup the existing configuration files...

```bash
mkdir $HOME/nginx-backup-$(date +%F_%H-%M-%S)
cp -a /etc/nginx/* $HOME/nginx-backup
```

As 'root', please use the following guidelines...
```bash
cd $HOME
git clone git://github.com/pothi/WordPress-Nginx.git $HOME/git/wp-nginx
cd $HOME/git/wp-nginx
git checkout centos
cp -a $HOME/git/wp-nginx/* /etc/nginx/
rm /etc/nginx/sites-enabled/domainname.conf
# Other steps that varies depending on your particular requirement:
# YOUR_DOMAIN_NAME=tinywp.com
# mv /etc/nginx/sites-available/domainname.conf /etc/nginx/sites-available/$YOUR_DOMAIN_NAME.conf
# cd /etc/nginx/sites-enabled/
# ln -s ../sites-available/$YOUR_DOMAIN_NAME.conf
# sed -i --follow-symlinks 's/domainname.com/'$YOUR_DOMAIN_NAME'/g' /etc/nginx/sites-enabled/$YOUR_DOMAIN_NAME.conf
# nginx -t && service nginx restart
```

### Changes compared to Debian derivatives

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
