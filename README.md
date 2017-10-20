# WordPress Nginx Configuration Templates

WordPress specific Nginx configurations, tweaks, and much more!

## Features

There are multiplpe advantages of using this repo as your go-to nginx configuration.

+ Correct use of `if` statement because [ifisevil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/).
+ SSL / LetsEncrypt / Certbot compatible.
+ Multisite support.
+ Contains ready-to-use sample vhost entries.
+ Continuously updated sample configurations with best practices.
+ Ansible friendly (coming soon)

## Available templates / vhost entries

+ WP Super Cache plugin (with support for SSL and separate mobile cache)
+ WP Rocket cache plugin (SSL / mobile supported out of the box)
+ Multisite (sub-domain and sub-directory)
+ Varnish with Nginx for SSL termination.
+ Custom error pages.

## Performance

+ All static content have maximum expiration headers.
+ SSL session cache is enabled by default.
+ [Google PageSpeed Module](https://developers.google.com/speed/pagespeed/module/) support.
+ Open file cache support.
+ Server-level 301 support (for http => https, non-www => www, etc).
+ [Autoptimize](https://wordpress.org/plugins/autoptimize/) support.

## Security

+ Support for [strong dhparam](https://weakdh.org/).
+ TLSv1 and other insecure protocols are disabled by default.
+ Mitigate [httpoxy](https://httpoxy.org/) vulnerability.
+ [HSTS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security) support.
+ All hidden and backup files are forbidden by default.

## Compatibility

Tested with the following servers...
+ Debian Debian 9 (Stretch)
+ Ubuntu 16.04 LTS (Xenial)

Test with the following Nginx versions...
+ Stable verisons 1.12.x
+ Mainline versions 1.13.x

For RPM based distros (Fedora, Redhat, CentOS and Amazon Linux AMI), the configuration mentioned in the repo should work. Additional steps may be needed, though. See below for some details!

## How to Deploy

For all the steps mentioned below, you need __sudo__ or __root__ privileges!

Step #1 - Install Nginx

You may use the official Nginx repo or just use the Nginx package that comes with the OS. Both would work fine! I will leave the decision to you. Since, the installation process varies across Operating Systems, please refer the official installation docs to complete this step.

Step #2 - Please backup your existing configuration files. Probably, have /etc under version control!

```bash
TIMESTAMP=$(date +%F_%H-%M-%S)
mkdir $HOME/nginx-backup-$TIMESTAMP
sudo cp -a /etc/nginx $HOME/nginx-backup-$TIMESTAMP
```

Step #3 - Copy this repo to your server.

```bash
git clone git://github.com/pothi/wordpress-nginx.git $HOME/git/wordpress-nginx
sudo cp -a $HOME/git/wordpress-nginx/* /etc/nginx/
sudo mkdir /etc/nginx/sites-enabled &> /dev/null
sudo cp /etc/nginx/nginx-sample.conf /etc/nginx/nginx.conf
```
Further steps varies depending on your particular requirement:

+ you may edit /etc/nginx/conf.d/lb.conf and update the upstream block for 'fpm' (one-off process)
+ then you may do the following for each vhost, depending on your environment...
```bash
WP_DOMAIN=example.com
WP_ROOT=/path/to/wordpress/for/example.com
sudo cp /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-available/$WP_DOMAIN.conf
sudo sed -i 's:/home/username/sites/example.com/public:'$WP_ROOT':gp' /etc/nginx/sites-available/$WP_DOMAIN.conf
sudo sed -i 's/example.com/'$WP_DOMAIN'/g' /etc/nginx/sites-available/$WP_DOMAIN.conf
cd /etc/nginx/sites-enabled/
sudo ln -s ../sites-available/$WP_DOMAIN.conf
sudo nginx -t && sudo systemctl restart nginx
```

### Changes on CentOS

CentOS has a different file naming convention, yet simple directory structure, when compared to Debian derivatives. Let me describe them and I'd let you decide upon how you'd want to structure your files and name those files.

+ The configuration for default sites are named as `default.conf` and `ssl.conf` in `/etc/nginx/conf.d/`.
+ There is no `sites-available` or `sites-enabled` folder.
+ The file `/etc/nginx/fastcgi_params` in Debian is named as `/etc/nginx/fastcgi.conf` in CentOS.

### About me

+ One of the top contributors for the tag [Nginx in ServerFault](https://serverfault.com/users/102173/pothi-kalimuthu?tab=profile).
+ Have released couple of WordPress Plugins, one of them is specifically for high performance WordPress sites... [https://profiles.wordpress.org/pothi#content-plugins](https://profiles.wordpress.org/pothi#content-plugins).
+ Have two _active_ blogs... [Tiny WordPress Insights](https://www.tinywp.in/) and [Tiny Web Performance Insights](https://www.tinywp.com/).

### Can you implement it on my server?

Yes, of course. My hourly rate is USD 50 per hour. Please [contact me](https://www.tinywp.in/contact/) for any queries in this regard.

### Have questions or just wanted to say hi?

Please ping me on [Twitter](https://twitter.com/pothi]) or [send me a message](https://www.tinywp.in/contact/).

If you find this repo useful, please spread the word! Suggestions, bug reports, future requests, forks are always welcome!
