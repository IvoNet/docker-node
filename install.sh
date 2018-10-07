#!/usr/bin/env bash

OVERRIDE=1
ClEAN_STATE=1 # Removes existing docker states (containers) of set to 1

create_run_script() {
    sed "s/CONTAINER/$1/g" run.template.sh > ~/bin/$1
    chmod +x ~/bin/$1
}

clean_state() {
    if [ $ClEAN_STATE == 1 ]; then
        if [ "$(docker ps -q -f name=$1)" ]; then
                echo "Remove running and existing container..."
                docker stop $1
                docker rm $1
        else
            if [ "$(docker ps -aq -f status=exited -f name=$1)" ]; then
                echo "Remove existing container..."
                docker rm $1
            fi
        fi
    fi
}
node_build() {
    sed "s/VERSION/$1/g" Dockerfile.template > Dockerfile
    cat Dockerfile
    docker build -t ivonet/$2 .
    if [ $OVERRIDE == 0 ]; then
        if [ -f ~/bin/$2 ]; then
            echo "Could not create executable ~/bin/$2 as it already exists"
        else
            create_run_script $2
        fi
    else
        create_run_script $2
    fi
    rm -f Dockerfile 2>/dev/null
    clean_state $2
}

#node_build 6.14.2-alpine node6
node_build 8.12.0-alpine node8
#node_build 9.11.1-alpine node9
node_build 10.11.0-alpine node10


docker rmi $(docker images -q -f dangling=true) 2>/dev/null
