server {
    listen 80;
    server_name wpsc.domainname.com;
    index index.php;

    # Replace the path with the actual path to WordPress core files
    root /home/username/sites/wpsc.domainname.com/wordpress;

    access_log /var/log/nginx/wpsc.domainname.com-access.log;
    error_log /var/log/nginx/wpsc.domainname.com-error.log;

    include "globals/common-locations.conf";

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        include                     fastcgi.conf;
        fastcgi_index               index.php;
        fastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_intercept_errors    on;
        fastcgi_pass                fpm;
    }

    include "globals/wpsc.conf";
}
