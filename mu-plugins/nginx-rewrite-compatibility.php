<?php

/*
Plugin Name: Nginx Rewrite Compatibility
Plugin URI: https://raw.github.com/pothi/WordPress-Nginx/master/mu-plugins/nginx-rewrite-compatibility.php
Version: 1.0
Author: <a href="https://www.tinywp.in/">Pothi Kalimuthu</a>
Description: To let WordPress know that the Nginx server supports mod_rewrite
*/

# Ref: http://blog.sjinks.pro/wordpress-plugins/nginx-compatibility/
# Ref: http://wordpress.org/extend/plugins/nginx-compatibility/
add_filter( 'got_rewrite', '__return_true' );
