#!/bin/bash

set -e

if [ ! -f "bake.sh" ]; then
    echo "Bakefile bake.sh not found" >&2
    exit 1
fi

if [ $# -lt 1 ]; then
    exit
fi

function __before {
    :
}

function __after {
    :
}

function __on_error {
    :
}

ACTION=$(echo $1 | sed 's/-/_/g')
shift 1

. bake.sh

__before
__$ACTION $@ || __on_error $ACTION
__after
