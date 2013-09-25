<?php

/*
 * Plugin Name:	Pagespeed compatibility
 * Plugin URI:	https://github.com/pothi/wordpress-mu-plugins
 * Version:		0.1
 * Description:	Add support for Pagespeed as a module or as a service
 * Author Name:	Pothi Kalimuthu
 * Author URI:	http://pothi.info
 */

/* Modified the code from http://w-shadow.com/blog/2012/07/30/automatic-versioning-of-css-js/ */

if ( !class_exists('TinyAutoVersioning') ) {

/**
 * This class enables automatic versioning of CSS/JS by adding file modification time to the URLs.
 * @see http://stackoverflow.com/questions/118884/
 */
class AutoVersioning {
	private static $version_in_filename = false;

	/**
	 * An auto-versioning wrapper for wp_register_s*() and wp_enqueue_s*() dependency APIs.
	 *
	 * @static
	 * @param string $wp_api_function The name of the WP dependency API to call.
	 * @param string $handle Script or stylesheet handle.
	 * @param string $src Script or stylesheet URL.
	 * @param array $deps Dependencies.
	 * @param bool|string $last_param Either $media (for wp_register_style) or $in_footer (for wp_register_script).
	 * @param bool $add_ver_to_filename TRUE = add version to filename, FALSE = add it to the query string.
	 */
	public static function add_dependency($wp_api_function, $handle, $src, $deps, $last_param, $add_ver_to_filename = false ) {
		list($src, $version) = self::auto_version($src, $add_ver_to_filename);
		call_user_func($wp_api_function, $handle, $src, $deps, $version, $last_param);
	}

	/**
	 * Automatically version a script or style sheet URL based on file modification time.
	 *
	 * Returns auto-versioned $src and $ver values suitable for use with WordPress dependency APIs like
	 * wp_register_script() and wp_register_style().
	 *
	 * @static
	 * @param string $url
	 * @param bool $add_ver_to_filename
	 * @return array array($url, $version)
	 */
	private static function auto_version($url, $add_ver_to_filename = false) {
		$version = false;
		$filename = self::guess_filename_from_url($url);

		if ( ($filename !== null) && is_file($filename) ) {
			$mtime = filemtime($filename);
			if ( $add_ver_to_filename ) {
				$url = preg_replace('@\.([^./\?]+)(\?.*)?$@', '.' . $mtime . '.$1', $url);
				$version = null;
			} else {
				$version = $mtime;
			}
		}

		return array($url, $version);
	}

	private static function guess_filename_from_url($url) {
		$url_mappings = array(
			plugins_url() => WP_PLUGIN_DIR,
			plugins_url('', WPMU_PLUGIN_DIR . '/dummy') => WPMU_PLUGIN_DIR,
			get_stylesheet_directory_uri() => get_stylesheet_directory(),
			get_template_directory_uri() => get_template_directory(),
			content_url() => WP_CONTENT_DIR,
			site_url('/' . WPINC) => ABSPATH . WPINC,
		);

		$filename = null;
		foreach($url_mappings as $root_url => $directory) {
			if ( strpos($url, $root_url) === 0 ) {
				$filename = $directory . '/' . substr($url, strlen($root_url));
				//Get rid of the query string, if any.
				list($filename, ) = explode('?', $filename, 2);
				break;
			}
		}

		return $filename;
	}

	/**
	 * Apply automatic versioning to all scripts and style sheets added using WP dependency APIs.
	 *
	 * If you set $add_ver_to_filename to TRUE, make sure to also add the following code to your
	 * .htaccess file or your site may break:
	 *
	 * <IfModule mod_rewrite.c>
	 *  RewriteEngine On
	 *  RewriteRule ^(.*)\.[\d]{10}\.(css|js)$ $1.$2 [L]
	 * </IfModule>
	 *
	 * @static
	 * @param bool $add_ver_to_filename
	 */
	public static function apply_to_all_dependencies($add_ver_to_filename = false) {
		self::$version_in_filename = $add_ver_to_filename;
		foreach(array('script_loader_src', 'style_loader_src') as $hook) {
			add_filter($hook, __CLASS__ . '::_filter_dependency_src', 10, 1);
		}
	}

	public static function _filter_dependency_src($src) {
		//Only add version info to CSS/JS files that don't already have it in the file name.
		if ( preg_match('@(?<!\.\d{10})\.(css|js)(\?|$)@i', $src) ) {
			list($src, $version) = self::auto_version($src, self::$version_in_filename);
			if ( !empty($version) ) {
				$src = add_query_arg('ver', $version, $src);
			}
		}
		return $src;
	}
}

} //class_exists()

if ( !function_exists('wp_register_auto_versioned_script') ) {
	function wp_register_auto_versioned_script($handle, $src, $deps = array(), $in_footer = false, $add_ver_to_filename = false) {
		AutoVersioning::add_dependency('wp_register_script', $handle, $src, $deps, $in_footer, $add_ver_to_filename);
	}
}

if ( !function_exists('wp_register_auto_versioned_style') ) {
	function wp_register_auto_versioned_style( $handle, $src, $deps = array(), $media = 'all', $add_ver_to_filename = false) {
		AutoVersioning::add_dependency('wp_register_style', $handle, $src, $deps, $media, $add_ver_to_filename);
	}
}

if ( !function_exists('wp_enqueue_auto_versioned_script') ) {
	function wp_enqueue_auto_versioned_script( $handle, $src, $deps = array(), $in_footer = false, $add_ver_to_filename = false ) {
		AutoVersioning::add_dependency('wp_enqueue_script', $handle, $src, $deps, $in_footer, $add_ver_to_filename);
	}
}

if ( !function_exists('wp_enqueue_auto_versioned_style') ) {
	function wp_enqueue_auto_versioned_style( $handle, $src, $deps = array(), $media = 'all', $add_ver_to_filename = false ) {
		AutoVersioning::add_dependency('wp_enqueue_style', $handle, $src, $deps, $media, $add_ver_to_filename);
	}
}

TinyAutoVersioning::apply_to_all_dependencies( true );

