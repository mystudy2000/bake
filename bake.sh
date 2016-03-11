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


. bake.sh

__before
__$@
__after
