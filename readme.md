# Bake

Bake is a modular task running tool written on pure bash.


# Usage

All you need is to create `bake.sh` into root of your project. Run `bake:init`
command. It will create empty `bake.sh` file and `bake_modules` directory.

Example bakefile for node.js package:

```bash
# bake.sh

# Initialize new node package
task:init() {
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
__() {
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

## Modules

Modules could be required with command `bake:module`:

```bash
bake:module mysql
bake:module ssh

ssh:set_user "root"
ssh:set_host "localhost"
ssh:set_key "~/.ssh/id_rsa"


task:run() {
    ssh:exec <<CMD
        service mysql start
CMD
    mysql:set_user "admin"
    mysql:set_password "********"

    mysql:query <<SQL
        SELECT name FROM database.table WHERE name="$1"
SQL
}
```

## Lookup and $PWD

Bake by default looking up the directory tree and search for `.bakerc` then `bake.sh`
file. After that bake switch `$PWD` to the project's root. Calling directory will be stored in `$CWD` variable.

Example:

```bash
# example/bake.sh
task:ls() {
    ls .
}
```

```bash
cd example/nest
bake ls # -> bake.sh nest
```


## License

MIT.
