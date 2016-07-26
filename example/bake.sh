# Run custom command
__() {
    echo UNKNOWN COMMAND "$1"
}

# Print current directory
task:pwd() {
    echo $PWD
}

# List bake dir
task:ls() {
    ls .
}
