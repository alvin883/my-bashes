<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'CLI_DATABASE_NAME' );

/** MySQL database username */
define( 'DB_USER', 'CLI_DATABASE_USER' );

/** MySQL database password */
define( 'DB_PASSWORD', 'CLI_DATABASE_PASSWORD' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '6S)g!=k=jX-txMj4}.;3#T?eHlx$ApZ-|5T$=,*7QI]B{.a@]SwR:5oMlR|+xk%F' );
define( 'SECURE_AUTH_KEY',  '898$3ax<dhZP[8_11>!~+fmu%LjYp`@_fz[gaIM?+1tAfu-lLoo(PAiqy.1HsEVM' );
define( 'LOGGED_IN_KEY',    '=8Nb^;[|~onRzJ7=<H*r@P;cInZSD?:t~+u$~ALMx?R|b$fVMTU;Ha*up}}P|xe>' );
define( 'NONCE_KEY',        ']<~-&Pl!nnFK=E[`7N$lI6v1`Y+v&k(pc?+^NqHN:ZbvrWt1l>`<|IT>4x]p_*y@' );
define( 'AUTH_SALT',        'T2oKMo^q?*%Q26.Q<g3gvr9chPPzLq.;GO|o4Qp3xGMl:w{P%&-2ht(#N0=FcvAr' );
define( 'SECURE_AUTH_SALT', 'px@k]@w#/8qv: )/N[~!%Ew:SFXfMy.|<ZpVEuS/a*ZR=:lA0&w^Cm^a5-|=,.xM' );
define( 'LOGGED_IN_SALT',   '?ORUnI&m{J@,EQE?z#afReA]dXP)^hQ+y^LHz{X(Mgf}8@c2&FJ4j#gNU93fwNA7' );
define( 'NONCE_SALT',       'tkwPur,PiwBv]iQRMN#W<_0{qX.X%O4Oi@[?#8r|0b9H&D79`r&<6=*I>DxNzyf)' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

define( 'FS_METHOD', 'direct' );
