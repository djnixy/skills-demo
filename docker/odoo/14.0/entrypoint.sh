#!/bin/bash

set -e

echo "Checking permissions of /etc/odoo/..."
ls -lah /etc/odoo

echo "Checking permissions of /var/lib/odoo/..."
ls -ld /var/lib/odoo


echo "Creating Odoo config from template..."
TMP_CONF="/tmp/odoo.conf"

if [ -f /etc/odoo/odoo.conf.tpl ]; then
    cp /etc/odoo/odoo.conf.tpl $TMP_CONF
    echo "Template copied to $TMP_CONF"
else
    echo "ERROR: /etc/odoo/odoo.conf.tpl not found!" >&2
    exit 1
fi

# Set default values and allow alternative env variables
DEFAULTS=(
    "ADMIN_PASSWD="
    "HTTP_ENABLE=True"
    "XMLRPC_PORT=8069"
    "LONGPOLLING_PORT=8072"
    "DB_HOST=${DB_HOST:-${HOST:-localhost}}"
    "DB_PORT=${DB_PORT:-${PORT:-5432}}"
    "DB_USER=${DB_USER:-${USER:-odoo}}"
    "DB_PASSWORD=${DB_PASSWORD:-${PASSWORD:-odoo}}"
    "DB_MAXCONN=10"
    "DB_SSLMODE=prefer"
    "DB_NAME=False"
    "DBFILTER=.*"
    "LIMIT_REQUEST=8192"
    "LIMIT_MEMORY_SOFT=2147483648"
    "LIMIT_MEMORY_HARD=2684354560"
    "LIMIT_TIME_CPU=60"
    "LIMIT_TIME_REAL=300"
    "LIST_DB=True"
    "LOG_DB=False"
    "LOG_LEVEL=info"
    "MAX_CRON_THREADS=1"
    "REDIS_SESSION=False"
    "REDIS_TYPE=standalone"
    "REDIS_HOST=localhost"
    "REDIS_PORT=6379"
    "REDIS_USERNAME="
    "REDIS_PASSWORD="
    "REDIS_EXPIRE=2592000"
    "REDIS_SSL=False"
    "SERVER_WIDE_MODULES=base,web"
    "PROXY_MODE=True"
    "WORKERS=0"
)

for def in "${DEFAULTS[@]}"; do
    key="${def%%=*}"
    val="${def#*=}"
    if [ -z "${!key}" ]; then
        export "$key"="$val"
        masked_val=$([[ "$key" =~ (ADMIN_PASSWD|DB_PASSWORD|PASSWORD) ]] && echo "******" || echo "$val")
        echo "Using default for $key: $masked_val"
    else
        masked_val=$([[ "$key" =~ (ADMIN_PASSWD|DB_PASSWORD|PASSWORD) ]] && echo "******" || echo "${!key}")
        echo "Using provided value for $key: $masked_val"
    fi
done

# Replace placeholders in the template
for VAR in $(compgen -e); do
    masked_val=$([[ "$VAR" =~ (ADMIN_PASSWD|DB_PASSWORD|PASSWORD) ]] && echo "******" || echo "${!VAR}")
    echo "Replacing $VAR in config (value: $masked_val)..."
    sed -i "s|{{${VAR}}}|${!VAR}|g" $TMP_CONF
done

echo "Moving generated config to /etc/odoo/odoo.conf..."
mv $TMP_CONF /etc/odoo/odoo.conf

echo "Final Odoo config (excluding sensitive values):"
sed -E 's/(admin_passwd\s*=).*/\1 ******/g; s/(db_password\s*=).*/\1 ******/g' /etc/odoo/odoo.conf

# Debugging environment variables
if [ "$DEBUG" = "true" ]; then
    echo "DEBUG: Printing Relevant Environment Variables..."
    env | grep -E "DB_|ADMIN_PASSWD|LOG_LEVEL|LIMIT_MEMORY" | sed -E 's/(ADMIN_PASSWD|DB_PASSWORD|PASSWORD)=[^ ]+/******/' 
    echo "------------------------------------------------------------"
fi

# Set the PostgreSQL database host, port, user, and password from environment variables
: ${DB_HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${DB_PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${DB_USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${DB_PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}

DB_ARGS=()

function check_config() {
    param="$1"
    value="$2"

    echo "Checking config for ${param}..."

    # Check if the parameter exists in /etc/odoo/odoo.conf
    if grep -q -E "^\s*\b${param}\b\s*=" "/etc/odoo/odoo.conf" ; then       
        # Extract the existing value from the config file
        extracted_value=$(grep -E "^\s*\b${param}\b\s*=" "/etc/odoo/odoo.conf" | cut -d " " -f3 | sed 's/["\n\r]//g')
        value="${extracted_value}"
        masked_value=$([[ "$param" =~ (db_password|ADMIN_PASSWD|PASSWORD) ]] && echo "******" || echo "$value")
        echo "Found ${param} in odoo.conf: $masked_value"
    else
        masked_value=$([[ "$param" =~ (db_password|ADMIN_PASSWD|PASSWORD) ]] && echo "******" || echo "$value")
        echo "${param} not found in odoo.conf. Using environment variable: $masked_value"
    fi

    # Append to DB_ARGS array
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}

check_config "db_host" "$DB_HOST"
check_config "db_port" "$DB_PORT"
check_config "db_user" "$DB_USER"
check_config "db_password" "$DB_PASSWORD"

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@"
        else
            wait-for-psql.py ${DB_ARGS[@]} --timeout=30
            exec odoo "$@" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        wait-for-psql.py ${DB_ARGS[@]} --timeout=30
        exec odoo "$@" "${DB_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
