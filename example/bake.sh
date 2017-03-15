bake:module hello_world

# Print current directory
task:pwd() {
    echo $PWD
}

# List bake dir
task:ls() {
    ls .
}

task:hello() {
  hello_world:print
}

task:env() {
  echo "ENV: ${NAME}"
}
