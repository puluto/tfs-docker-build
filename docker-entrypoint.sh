#!/bin/sh

set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
    echo >&2 'Please read the docs and use this docker image.'
fi

exec "$@"
