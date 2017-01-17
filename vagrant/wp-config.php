<?php
define('DB_NAME', '{{db_name}}');
define('DB_USER', '{{db_user}}');
define('DB_PASSWORD', '{{db_password}}');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
define('AUTH_KEY',         'x4(x4XHq;tDe!bh-Z4g]{TX*IAK5J+?6AoA_Wcv-<{+37HS=WHjHwuQDJ(saY?@U');
define('SECURE_AUTH_KEY',  '/ &p?6<AmJ9tPBg_yVQ)mL;[!=>Gb?B@6Hce|(r@{`dPxy_)lbE;ZfIQOL>~dEH)');
define('LOGGED_IN_KEY',    'dZ.v38@AN(t9J-d.i#,l8w0F&X_R71{2/y0=IAEvND7jgWA;Qw/RSCze20TOSG3a');
define('NONCE_KEY',        ']Ib5|2K7&u40PBY|T9ZA/J~/Xsc/G%A3G|6ye8iuG&~0QDCH5dm}b9:G{<IE9RL}');
define('AUTH_SALT',        '-v23!J<6Qk!m)b6upQ+_,F5+O`y<fP&Sh[:gawqHx RAy?hPN2A1u|WLkigJ >Gn');
define('SECURE_AUTH_SALT', '~N_%dOAvRcMc]rJqv5<W8[Yi~5AqB.>@l]z38POvYW]^:0Q~&BO%f#%htJ1,S!J1');
define('LOGGED_IN_SALT',   'PK0~.69&56gA4]eLXMqJGG*c)2OLeZC}gG)-M8Z:5VQ;j/At[pj<=-^wV%hBUk|m');
define('NONCE_SALT',       '&-!_ea88XztGho.MAg7c?e-W|TB9[l6;(q-+<Uep><^;7Ct{~47_Z,mX+8~(pv`*');
$table_prefix  = 'wotwp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
