#!/bin/bash

set -e

echo "Checking permissions of /etc/odoo/..."
ls -lah /etc/odoo

echo "Checking permissions of /var/lib/odoo/..."
ls -ld /var/lib/odoo


echo "Creating Odoo config from template..."
TMP_CONF="/tmp/odoo.conf"

if [[ -f /etc/odoo/odoo.conf.tpl ]]; then
    cp /etc/odoo/odoo.conf.tpl $TMP_CONF
    echo "Template copied to $TMP_CONF"
else
    echo "ERROR: /etc/odoo/odoo.conf.tpl not found!" >&2
    exit 1
fi

if [[ -z "${DB_NAME}" ]]; then
    sed -i '/{{DB_NAME}}/d' $TMP_CONF
fi

if [[ -z "${LOG_DB}" ]]; then
    sed -i '/{{LOG_DB}}/d' $TMP_CONF
fi

if [[ -z "${ADMIN_PASSWD}" ]]; then
    export ADMIN_PASSWD=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 20)
    echo "ADMIN_PASSWD not provided. Generated a random 20-character alphanumeric password."
fi

# Set default values and allow alternative env variables
DEFAULTS=(
    "ADDONS_PATH"=${ADDONS_PATH:-/mnt/extra-addons}
    "DATA_DIR"=${DATA_DIR:-/var/lib/odoo}
    "ADMIN_PASSWD"=${ADMIN_PASSWD}
    "HTTP_ENABLE"=${HTTP_ENABLE:-True}
    "HTTP_PORT"=${HTTP_PORT:-8069}
    "HTTP_INTERFACE"=${HTTP_INTERFACE:-0.0.0.0}
    "DB_HOST"=${DB_HOST:-${HOST:-db}}
    "DB_PORT"=${DB_PORT:-${PORT:-5432}}
    "DB_USER"=${DB_USER:-${POSTGRES_USER:-odoo}}
    "DB_PASSWORD"=${DB_PASSWORD:-${POSTGRES_PASSWORD}}
    "DB_MAXCONN"=${DB_MAXCONN:-100}
    "DB_SSLMODE"=${DB_SSLMODE:-prefer}
    "DB_NAME"=${DB_NAME}
    "DBFILTER"=${DBFILTER:-.*}
    "LIMIT_REQUEST"=${LIMIT_REQUEST:-8192}
    "LIMIT_MEMORY_SOFT"=${LIMIT_MEMORY_SOFT:-2147483648}
    "LIMIT_MEMORY_HARD"=${LIMIT_MEMORY_HARD:-2684354560}
    "LIMIT_TIME_CPU"=${LIMIT_TIME_CPU:-60}
    "LIMIT_TIME_REAL"=${LIMIT_TIME_REAL:-300}
    "LIST_DB"=${LIST_DB:-True}
    "LOG_DB"=${LOG_DB}
    "LOG_LEVEL"=${LOG_LEVEL:-info}
    "MAX_CRON_THREADS"=${MAX_CRON_THREADS:-1}
    "SERVER_WIDE_MODULES"=${SERVER_WIDE_MODULES:-base,web}
    "PROXY_MODE"=${PROXY_MODE:-True}
    "WORKERS"=${WORKERS:-0}
)

for def in "${DEFAULTS[@]}"; do
    key="${def%%=*}"
    val="${def#*=}"
    if [[ -z "${!key}" ]]; then
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
    
    # Safely escape pipes so sed doesn't crash if a password contains a '|'
    safe_val=$(printf '%s\n' "${!VAR}" | sed 's/|/\\|/g')
    sed -i "s|{{${VAR}}}|${safe_val}|g" "$TMP_CONF"
done

echo "Moving generated config to /etc/odoo/odoo.conf..."
mv $TMP_CONF /etc/odoo/odoo.conf

echo "Final Odoo config (excluding sensitive values):"
sed -E 's/(admin_passwd\s*=).*/\1 ******/g; s/(db_password\s*=).*/\1 ******/g' /etc/odoo/odoo.conf

# Debugging environment variables
if [[ "$DEBUG" = "true" ]]; then
    echo "DEBUG: Printing Relevant Environment Variables..."
    env | grep -E "DB_|ADMIN_PASSWD|LOG_LEVEL|LIMIT_MEMORY" | sed -E 's/^(.*(ADMIN_PASSWD|DB_PASSWORD|PASSWORD))=.*$/\1=******/g' || true
    echo "------------------------------------------------------------"
fi

DB_ARGS=()

function check_config() {
    param="$1"
    value="$2"

    echo "Checking config for ${param}..."

    # Check if the parameter exists in /etc/odoo/odoo.conf
    if grep -q -E "^\s*\b${param}\b\s*=" "/etc/odoo/odoo.conf" ; then       
        extracted_value=$(grep -E "^\s*\b${param}\b\s*=" "/etc/odoo/odoo.conf" | awk -F '=' '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/["\n\r]//g')
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

exec "$@"
