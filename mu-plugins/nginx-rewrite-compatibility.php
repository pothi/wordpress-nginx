<?php

/*
Plugin Name: Nginx Rewrite Compatibility
Plugin URI: http://wordpress.org/extend/plugins/nginx-compatibility/
Version: 0.2.5
Author: <a href="http://profiles.wordpress.org/vladimir_kolesnikov/">Vladimir Kolesnikov</a>
Description: A simplified one-line version of Nginx compatibility plugin
*/

# To let WordPress know that the server has mod_rewrite
# Ref: http://blog.sjinks.pro/wordpress-plugins/nginx-compatibility/
# Ref: http://wordpress.org/extend/plugins/nginx-compatibility/

add_filter( 'got_rewrite', '__return_true', 999 );
