#!/usr/bin/env sh
set -e

ROLE=${ROLE:-app}

if [ -n "$1" ]; then
    echo "Executing $1"
    exec "$@"
else
    if [ "$ROLE" = "app" ]; then
        exec php-fpm
    elif [ "$ROLE" = "setup" ]; then
        php artisan app:setup
    elif [ "$ROLE" = "scheduler" ]; then
        su -s '/bin/sh' -c 'php artisan schedule:work --quiet' www-data
    elif [ "$ROLE" = "queue" ]; then
        su -s '/bin/sh' -c 'php artisan queue:work --tries=3 --timeout=90 --quiet' www-data
    else
        echo "Unknown role '$ROLE'"
        exit 1
    fi
fi
