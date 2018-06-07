#!/bin/sh
NAME=CONTAINER

if [ "$1" == "." ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${NAME})" ]; then
        echo "Resetting state..."
        docker rm ${NAME} >/dev/null
    fi
fi

if [ "$(docker ps -q -f name=${NAME})" ]; then
        echo "Attaching to running container..."
        docker attach ${NAME}
else
    if [ "$(docker ps -aq -f status=exited -f name=${NAME})" ]; then
        echo "Start existing container..."
        docker start -i ${NAME}
    else
        echo "Init CONTAINER container..."
        docker run -it --name ${NAME} -v "$(pwd):/project" -p 3000:3000 ivonet/${NAME}
    fi
fi