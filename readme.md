# Bake

Bake is a bash task running tool.


# Usage

All you need is to create `bake.sh` into root of your project.

Example bakefile for node.js package:

```bash
# bake.sh

# Initialize new node package
function __init {
    git init
    {
        echo "tmp"
        echo "**/.DS_Store"
        echo "**/npm-debug.log"
        echo "node_modules"
    } > .gitignore
    mkdir src test
    npm init

    git add .gitignore package.json
    git commit -m 'Initial commit'
}

# Pass unknown commands to `npm run`
function __ {
    local SCRIPT=$1
    shift 1
    npm run $SCRIPT -- $@ <&1
}
```

Now you can run `init` task:

```shell
bake init
```

This will initialize your empty package project.

## Lookup and $PWD

Bake by default looking up the directory tree and search for `.bakerc` then `bake.sh`
file. After that bake switch `$PWD` to the project's root. Calling directory will be stored in `$CWD` variable.

Example:

```bash
# example/bake.sh
function __ls {
    ls .
}
```

```shell
cd example/nest
bake ls # -> bake.sh nest
```
