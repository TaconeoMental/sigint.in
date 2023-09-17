#!/bin/bash

VOLUMES=("sigint.in_caddy_config" "sigint.in_caddy_data")
DOCKERCOMPOSE="docker compose --file docker-compose.yml"

function create_volumes() {
	for volume in "${VOLUMES[@]}"
	do
        echo -n "[*] Volume '$volume' "
        # "--format json" is just to remove the table header the default template shows :P
        vol_info=$(docker volume ls -f name=$volume --format json | awk '{print $NF}')
        if [ $vol_info ]
        then
            echo "already exists"
        else
            echo "does not exist. Creating..."
            docker volume create $volume
        fi
	done
}

function sigint_init() {
    create_volumes
    $DOCKERCOMPOSE up -d
    echo "Web server is now running :)"
}

function sigint_start() {
    $DOCKERCOMPOSE start
    echo "Web server is now running :)"
}

function sigint_stop() {
    $DOCKERCOMPOSE start
}

function sigint_down() {
    $DOCKERCOMPOSE down
}

function sigint_help() {
    echo "$0 [ init | start | stop | down ]"
}

if [ $# -eq 0 ]; then
  sigint_help
  exit 1
fi

case $1 in
  "init")
    sigint_init
    ;;
  "start")
    sigint_start
    ;;
  "stop")
    sigint_stop
    ;;
  "down")
    sigint_down
    ;;
  *)
    $DOCKERCOMPOSE $@
    ;;
esac

exit 0

create_volumes

