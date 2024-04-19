_default:
    @just --list --unsorted

HERE           := justfile_directory()
COMPOSE_FILE   := HERE / "docker-compose.yml"
DOCKER_COMPOSE := "docker compose --file " + COMPOSE_FILE
WEB_SERVICE    := "caddy"

set dotenv-load

create_volumes:
    #!/usr/bin/env bash
    set -euo pipefail
    VOLUMES=("sigint.in_caddy_config" "sigint.in_caddy_data")
    for volume in "${VOLUMES[@]}";
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

init: create_volumes
    {{DOCKER_COMPOSE}} up --detach {{WEB_SERVICE}}

start:
    {{DOCKER_COMPOSE}} start {{WEB_SERVICE}}

stop:
    {{DOCKER_COMPOSE}} stop {{WEB_SERVICE}}

down:
    -{{DOCKER_COMPOSE}} down {{WEB_SERVICE}}

run_jekyll:
    {{DOCKER_COMPOSE}} run --rm -it jekyll bash -c "gem install jekyll-tagging"

@compile:
    #!/usr/bin/env bash
    set -euo pipefail
    cp -r {{HERE}}/src/posts/* {{HERE}}/jekyll/_posts/
    cp -r {{HERE}}/src/assets/{css,images} {{HERE}}/jekyll/assets/
    cp -r {{HERE}}/src/assets/sass {{HERE}}/jekyll/_sass/
    find {{HERE}}/src/ -maxdepth 1 -type f -exec cp -t {{HERE}}/jekyll/ {} +
    {{DOCKER_COMPOSE}} run --rm jekyll bash -c "jekyll build" && \
        cp -r {{HERE}}/jekyll/_site/* {{HERE}}/server/root/ && \
        echo "Done"
