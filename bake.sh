#!/bin/bash

set -e

BAKEFILE="bake.sh";

if [ -f ".bakerc" ]; then
    . ".bakerc"

    # Require bake template
    if [ ! -z "$BAKE_BASE" ]; then
        . $BAKE_BASE
    fi
fi

if [ ! -f "$BAKEFILE" ]; then
    echo "Bakefile ${BAKEFILE} not found" >&2
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

. $BAKEFILE

__before
__$ACTION $@ || __on_error $ACTION
__after
