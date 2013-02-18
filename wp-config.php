<?php

/* If the IP of the commenters show as 127.0.0.1
 *     then, ask your host / sysadmin to fix it
 *     else use the following code
 * What does it do?
 *     It checks the presence of X-Forwarded-For header and if it contains a valid IP
 *     If that exists, it assigns it as client IP
 * Warning: It is not a recommended solution.
 */
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_FOR'] ) && preg_match( '/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/', $_SERVER['HTTP_X_FORWARDED_FOR'] ) )
		$_SERVER['REMOTE_ADDR'] = $_SERVER['HTTP_X_FORWARDED_FOR'];
