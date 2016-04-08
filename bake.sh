#!/bin/bash

set -e

BAKE_VERSION=0.5.1
BAKEFILE="bake.sh";

if [ -f ".bakerc" ]; then
    . ".bakerc"

    # Require bake template
    if [ ! -z "$BAKE_BASE" ]; then
        . $BAKE_BASE
    fi
fi

case $1 in
    -v)
        echo $BAKE_VERSION
        exit
    ;;
    -h)
        echo "Usage is: $@ <ACTION> [OPTIONS]" >&2
        exit 1
    ;;
esac

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

set -e


. $BAKEFILE

function is_a_func {
    type $1 2>/dev/null | grep -q "is a function"
}

if ! is_a_func __$ACTION
then
    if is_a_func __
    then
        ACTION=" $ACTION"
    else
        echo "Action '$ACTION' is not defined" >&2
        exit 1
    fi
fi

__before
__$ACTION $@ || __on_error $ACTION
__after
