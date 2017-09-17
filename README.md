# WordPress Nginx Configuration Templates

WordPress specific Nginx configurations, tweaks, and much more!

## Features

There are multiplpe advantages of using this repo as your go-to nginx configuration.

+ Contains ready-to-use sample vhost entries (or templates) to be used with WP Super Cache plugin, WP Rocket cache plugin, Varnish, etc.
+ Uses best practices (ex: you can find the correct use 'if' statement in most templates in this repo).
+ SSL compatible
+ Continuously updated sample configurations and best practices.

## Compatibility

Tested with 
+ Debian Debian 9
+ Ubuntu 16.04 LTS

For Fedora, Redhat, CentOS and Amazon Linux AMI or similar distributions, the configuration mentioned in the repo should work. Additional steps may be needed, though. See below for some details!

## How to Deploy

For all the steps mentioned below, you may need __sudo__ or __root__ privileges!

Step #1 - Install Nginx

You may use the official Nginx repo or just use the Nginx package that comes with the OS. Both would work fine! I will leave the decision to you. Since, the installation process varies across Operating Systems, please refer the official installation docs to complete this step.

Step #2 - Please backup your existing configuration files.

```bash
TIMESTAMP=$(date +%F_%H-%M-%S)
mkdir $HOME/nginx-backup-$TIMESTAMP
sudo cp -a /etc/nginx $HOME/nginx-backup-$TIMESTAMP
```

Step #3 - Copy this repo to your server.

```bash
git clone git://github.com/pothi/wordpress-nginx.git $HOME/git/wordpress-nginx
cd $HOME/git/wordpress-nginx

sudo cp -a $HOME/git/wordpress-nginx/* /etc/nginx/
sudo mkdir /etc/nginx/sites-enabled &> /dev/null
sudo cp /etc/nginx/nginx-sample.conf /etc/nginx/nginx.conf
```
Further steps varies depending on your particular requirement:

+ you may edit /etc/nginx/conf.d/lb.conf and update the upstream block for 'fpm' (one-off process)
+ then you may do the following for each vhost, depending on your environment...
```bash
WP_DOMAIN=example.com
YOUR_USERNAME=your_linux_username
sudo cp /etc/nginx/sites-available/example.com.conf /etc/nginx/sites-available/$WP_DOMAIN.conf
sudo sed -i 's/example.com/'$WP_DOMAIN'/g' /etc/nginx/sites-available/$WP_DOMAIN.conf
sudo sed -i 's/username/'$YOUR_USERNAME'/g' /etc/nginx/sites-available/$WP_DOMAIN.conf
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

### Can you implement it for me?

Yes, of course. But, for a small fee of USD 5 per server per site. [Reach out to me now!](https://www.tinywp.in/contact/).

### Have questions or just wanted to say hi?

Please ping me on [Twitter](https://twitter.com/pothi]) or [send me a message](https://www.tinywp.in/contact/).

If you find this repo useful, please spread the word!

Suggestions, bug reports, issues, forks are always welcome!
