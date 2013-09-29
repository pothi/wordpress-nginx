<?php

/*
Plugin Name: Nginx Rewrite Compatibility
Plugin URI:	https://github.com/pothi/WordPress-Nginx/blob/master/mu-plugins/nginx-rewrite-compatibility.php
Version:	1.0
Author:		Pothi Kalimuthu
Author URI:	https://www.tinywp.in
Description: To let WordPress know that the Nginx supports rewrites
*/

# Ref: http://blog.sjinks.pro/wordpress-plugins/nginx-compatibility/
# Ref: http://wordpress.org/extend/plugins/nginx-compatibility/
add_filter( 'got_rewrite', '__return_true' );
