#!/bin/bash

set -e

BAKE_VERSION=0.6.0
BAKEFILE="bake.sh";

# Split string (arg #2) into array by separator (arg #1)
function split {
    local IFS=$1
    set -f
    local arr=($2)
    set +f
    printf '%s\n' "${arr[@]}"
}

# Search file (arg #2) up the path (arg #1).
function lookup {
    local D=$1
    local FILENAME=$2
    arr=($(split "/" $D))


    for i in $(seq `expr ${#arr[@]} - 1` -1 0)
    do
        DIR="/"
        FOUND=""
        for n in `seq 0 $i`
        do
            DIR=${DIR}${arr[$n]}/
        done
        FILE=${DIR}${FILENAME}
        if [ -f "$FILE" ]
        then
            echo $FILE
            break
        fi
    done
}

BAKERC=`lookup $PWD ".bakerc"`

if [ -n "$BAKERC" ] && [ -f "$BAKERC" ]; then
    BAKEDIR=`dirname $BAKERC`

    . "$BAKERC"

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

if [ -z "$BAKEDIR" ]
then
    BAKEFILE=`lookup $PWD $BAKEFILE`
    BAKEDIR=`dirname $BAKEFILE`
else
    BAKEFILE=$BAKEDIR/$BAKEFILE
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

CWD=$PWD
cd $BAKEDIR

__before
__$ACTION $@ || __on_error $ACTION
__after
