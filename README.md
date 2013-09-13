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
TIMESTAMP=$(date +%F_%H-%M-%S)
mkdir $HOME/nginx-backup-$TIMESTAMP
cp -a /etc/nginx/* $HOME/nginx-backup-$TIMESTAMP
```

As 'root', please use the following guidelines...
```bash
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

## Questions, Issues or Bugs?

+ Please submit issues or bugs via Github
+ Patches, improvements, and suggestions are welcomed.
+ Please use contact form at https://www.tinywp.in/contact/ , if you'd like to contact Pothi Kalimuthu for other reasons.
+ I'm available for hire to setup, tweak or troubleshoot your server to provide *the fastest WordPress hosting*.
+ Thanks for having a look here. Have a good time!
