# Bake

Bake is a bash task running tool.


# Usage

All you need is to create `bake.sh` into root of your project and run task from
it with simple commands:

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

Run `init` task:

```shell
bake init
```
