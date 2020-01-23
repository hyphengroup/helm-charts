#!/bin/bash
# set -eu
set -e

readonly TRY_LOOP="20"
readonly DOCKER_BOOTSTRAPPED=".bootstrapped"
wait_for_port() {
  local name="$1" host="$2" port="$3"
  local j=0
  while ! nc -z "$host" "$port" >/dev/null 2>&1 < /dev/null; do
    j=$((j+1))
    if [ $j -ge $TRY_LOOP ]; then
      echo >&2 "$(date) - $host:$port still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for $name... $j/$TRY_LOOP"
    sleep 5
  done
}


# Ensure Apache PID lock file is removed (prevents common issue with volumes)
rm -f /run/apache2/apache2.pid

# render php.ini (expects ${REDIS_HOST and $REDIS_PORT})
envsubst </usr/local/etc/php/conf.d/docker.ini >/usr/local/etc/php/conf.d/docker.ini

readonly CONFIG_SI_FILE="/var/www/html/config_si.php"

CURRENCY_ISO4217="${CURRENCY_ISO4217:-USD}"
CURRENCY_NAME="${CURRENCY_NAME:-US Dollar}"
DATE_FORMAT="${DATE_FORMAT:-d-m-Y}"
EXPORT_CHARSET="${EXPORT_CHARSET:-ISO-8859-1}"
DEFAULT_LANGUAGE="${DEFAULT_LANGUAGE:-en_us}"
POPULATE_DEMO_DATA="${POPULATE_DEMO_DATA:-false}" # Not yet implemented

write_suitecrm_config() {
    echo "Write config_si file..."
    cat <<EOL > ${CONFIG_SI_FILE}
<?php
\$sugar_config_si  = array (
    'dbUSRData' => 'create',
    'default_currency_iso4217' => '${CURRENCY_ISO4217}',
    'default_currency_name' => '${CURRENCY_NAME}',
    'default_currency_significant_digits' => '2',
    'default_currency_symbol' => '$',
    'default_date_format' => '${DATE_FORMAT}',
    'default_decimal_seperator' => '.',
    'default_export_charset' => '${EXPORT_CHARSET}',
    'default_language' => '${DEFAULT_LANGUAGE}',
    'default_locale_name_format' => 's f l',
    'default_number_grouping_seperator' => ',',
    'default_time_format' => 'H:i',
    'export_delimiter' => ',',
    'setup_db_admin_password' => '${DB_PASSWORD}',
    'setup_db_admin_user_name' => '${DB_USER}',
    'setup_db_create_database' => 1,
    'setup_db_database_name' => '${DB_NAME}',
    'setup_db_drop_tables' => 0,
    'setup_db_host_name' => '${DB_HOST}',
    'setup_db_pop_demo_data' => false,
    'setup_db_type' => '${DB_TYPE}',
    'setup_db_username_is_privileged' => true,
    'setup_site_admin_password' => '${ADMIN_PASSWORD}',
    'setup_site_admin_user_name' => '${ADMIN_NAME}',
    'setup_site_url' => '${SITE_URL}',
    'setup_system_name' => '${SITE_NAME}',
    'external_cache_force_backend' => 'redis'
  );
EOL
}

if [ ! -e ${DOCKER_BOOTSTRAPPED} ]; then
    write_suitecrm_config
    cat ${CONFIG_SI_FILE}

    wait_for_port "Mysql" "${DB_HOST}" "3306"
    wait_for_port "Redis" "${REDIS_HOST}" "${REDIS_PORT}"
    echo "Configuring suitecrm for first run"

    echo "##############################################################"
    echo "##Running silent install, will take a couple of minutes ... ##"
    echo "##############################################################"

    # cp /config_si.php .
    # chown ${WWW_USER}:${WWW_GROUP} config_si.php
    php -r "\$_SERVER['HTTP_HOST'] = 'localhost'; \$_SERVER['REQUEST_URI'] = 'install.php';\$_REQUEST = array('goto' => 'SilentInstall', 'cli' => true);require_once 'install.php';";
    chown -R ${WWW_USER}:${WWW_GROUP} .
    chmod -R 755 .
    chmod -R 775 cache custom modules themes data upload

    echo "##############################################################"
    echo "##SuiteCRM is ready to use, enjoy it                        ##"
    echo "##############################################################"

    touch ${DOCKER_BOOTSTRAPPED}
fi

# mysql -u {username} -p{password} -h {remote server ip} {DB name}
if [ "$1" = "dbdump" ]; then
    echo "[dbdump] Dumping DB..."
    mysqldump -u $DB_USER -p '$DB_PASSWORD' -h $DB_HOST $DB_NAME
elif [ "$1" = "dbimport" ]; then
    echo "[dbimport] Importing DB..."
    mysql -u $DB_USER -p $DB_PASSWORD -h $DB_HOST $DB_NAME < /dev/stdin
else
    # start cron in background
    /usr/sbin/cron
    # replace shell with passed in argument
    exec "$@"
fi
