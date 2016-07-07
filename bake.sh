#!/bin/bash

set -e

BAKEEXE=$(readlink -f $0)

BAKE_VERSION=0.8.0
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
    if [ -n "$BAKEFILE" ]
    then
        BAKEDIR=`dirname $BAKEFILE`
    else
        BAKEDIR=$PWD
    fi
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

function __on_error {
    :
}

if [ "${1:0:1}" = "-" ] && [ ${#1} = 2 ]
then
    case $1 in
        "-l") # List used defined commands

            . $BAKEFILE
            FUNCTIONS=`declare -F | awk '{ print $3 }'`
            for FUNC in $FUNCTIONS
            do
                if [ ${FUNC:0:2} = "__" ]
                then
                    LENGTH=`expr ${#FUNC} - 2`
                    NAME=`echo ${FUNC:2:$LENGTH} | sed 's/_/-/g'`
                    echo $NAME
                fi
            done
            ;;
        "-v") # Bake version output
            echo $BAKE_VERSION;
            ;;
        ?) echo "Unknown flag $1"
            exit 1;
        ;;
    esac
    exit;
fi

ACTION=$(echo $1 | sed 's/-/_/g')
shift 1

if [ -n "$BAKE_ENV" ]
then
    . ./bake-${BAKE_ENV}.sh
fi

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


is_a_func __before && __before
__$ACTION $@ || __on_error $ACTION
is_a_func __after && __after
